// =============================================================
// 📁 core/auth/auth_storage.dart
// =============================================================
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/data/models/response/auth_response_dto.dart';

/// 🔐 인증 정보 보안 저장소
///
/// flutter_secure_storage를 사용하여 JWT 토큰을 안전하게 저장합니다.
/// iOS: Keychain, Android: EncryptedSharedPreferences 사용
class AuthStorage {
  // =============================================================
  // 🔧 설정
  // =============================================================

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,  // Android 암호화 저장소 사용
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_PKCS1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,  // 첫 잠금해제 후 접근
    ),
  );

  // 저장 키 상수
  static const String _accessTokenKey = 'mind_canvas_access_token';
  static const String _refreshTokenKey = 'mind_canvas_refresh_token';
  static const String _authResponseKey = 'mind_canvas_auth_response';
  static const String _tokenIssuedAtKey = 'mind_canvas_token_issued_at';

  // =============================================================
  // 💾 토큰 저장/로드
  // =============================================================

  /// 🔐 AuthResponse 전체 저장 (JSON 직렬화)
  static Future<void> saveAuthResponse(AuthResponse authResponse) async {
    try {
      // AuthResponse를 JSON으로 직렬화하여 저장
      final jsonString = jsonEncode(authResponse.toJson());
      await _storage.write(key: _authResponseKey, value: jsonString);

      // 발급 시간도 함께 저장
      final issuedAt = DateTime.now().toIso8601String();
      await _storage.write(key: _tokenIssuedAtKey, value: issuedAt);

      print('✅ 인증 정보 저장 완료');
    } catch (e) {
      print('❌ 인증 정보 저장 실패: $e');
      rethrow;
    }
  }

  /// 🔐 AuthResponse 전체 로드
  static Future<AuthResponse?> loadAuthResponse() async {
    try {
      final jsonString = await _storage.read(key: _authResponseKey);
      if (jsonString == null) return null;

      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return AuthResponse.fromJson(jsonMap);
    } catch (e) {
      print('❌ 인증 정보 로드 실패: $e');
      return null;
    }
  }

  /// 📅 토큰 발급 시간 로드
  static Future<DateTime?> loadTokenIssuedAt() async {
    try {
      final issuedAtString = await _storage.read(key: _tokenIssuedAtKey);
      if (issuedAtString == null) return null;

      return DateTime.parse(issuedAtString);
    } catch (e) {
      print('❌ 토큰 발급 시간 로드 실패: $e');
      return null;
    }
  }

  /// 🎫 Access Token만 개별 저장 (필요 시)
  static Future<void> saveAccessToken(String accessToken) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
  }

  /// 🎫 Access Token만 개별 로드
  static Future<String?> loadAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// 🔄 Refresh Token만 개별 저장 (필요 시)
  static Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  /// 🔄 Refresh Token만 개별 로드
  static Future<String?> loadRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // =============================================================
  // 🗑️ 토큰 삭제
  // =============================================================

  /// 🧹 모든 인증 정보 삭제 (로그아웃)
  static Future<void> clearAll() async {
    try {
      await Future.wait([
        _storage.delete(key: _authResponseKey),
        _storage.delete(key: _tokenIssuedAtKey),
        _storage.delete(key: _accessTokenKey),
        _storage.delete(key: _refreshTokenKey),
      ]);
      print('✅ 모든 인증 정보 삭제 완료');
    } catch (e) {
      print('❌ 인증 정보 삭제 실패: $e');
      rethrow;
    }
  }

  /// 🗑️ 특정 키만 삭제
  static Future<void> deleteKey(String key) async {
    await _storage.delete(key: key);
  }

  // =============================================================
  // 🔍 상태 확인
  // =============================================================

  /// 📱 저장된 토큰이 있는지 확인
  static Future<bool> hasAuthResponse() async {
    final authResponse = await loadAuthResponse();
    return authResponse != null;
  }

  /// 📋 저장된 모든 키 조회 (디버깅용)
  static Future<Map<String, String>> getAllStoredData() async {
    return await _storage.readAll();
  }

  /// 🧹 전체 저장소 초기화 (디버깅용)
  static Future<void> clearAllStoredData() async {
    await _storage.deleteAll();
    print('🧹 전체 보안 저장소 초기화 완료');
  }

  // =============================================================
  // 🚀 편의 메서드들
  // =============================================================

  /// 🔐 완전한 인증 정보 저장 (AuthResponse + 발급시간)
  static Future<AuthResponse?> loadCompleteAuthData() async {
    try {
      // 1. 기본 AuthResponse 로드
      final auth = await loadAuthResponse();
      if (auth == null) {
        print('ℹ️ 저장된 AuthResponse 없음');
        return null;
      }

      // 2. 토큰 발급시간 로드
      final issuedAt = await loadTokenIssuedAt();
      if (issuedAt == null) {
        print('⚠️ 토큰 발급시간 없음 - 현재 시간으로 설정');
        // 발급시간이 없으면 현재 시간으로 설정 (하위 호환성)
        return auth.copyWith(issuedAt: DateTime.now());
      }

      // 3. 발급시간이 포함된 완전한 AuthResponse 반환
      final completeAuth = auth.copyWith(issuedAt: issuedAt);

      print('✅ 완전한 인증 정보 로드 성공: ${completeAuth.toSafeString}');
      return completeAuth;

    } catch (e) {
      print('❌ 완전한 인증 정보 로드 실패: $e');
      // 오류 발생 시 안전하게 null 반환
      return null;
    }
  }

  /// 🔐 완전한 인증 정보 저장 (AuthResponse + 발급시간)
  ///
  /// AuthResponse와 현재 시간을 발급시간으로 함께 저장
  /// 개별 토큰도 빠른 접근을 위해 별도 저장
  static Future<void> saveCompleteAuthData(AuthResponse authResponse) async {
    try {
      // 현재 시간을 발급시간으로 설정하여 저장
      final authWithIssuedAt = authResponse.copyWith(issuedAt: DateTime.now());

      // 1. 완전한 AuthResponse 저장
      await saveAuthResponse(authWithIssuedAt);

      // 2. 개별 토큰도 저장 (빠른 접근용)
      await Future.wait([
        saveAccessToken(authResponse.accessToken),
        saveRefreshToken(authResponse.refreshToken),
      ]);

      print('✅ 완전한 인증 정보 저장 성공');
    } catch (e) {
      print('❌ 완전한 인증 정보 저장 실패: $e');
      rethrow;
    }
  }
}

// =============================================================
// 🎯 사용 예시
// =============================================================

/*
// 1. 로그인 성공 시 저장
final authResponse = AuthResponse(...);
await AuthStorage.saveCompleteAuthData(authResponse);

// 2. 앱 시작 시 로드
final authData = await AuthStorage.loadCompleteAuthData();
if (authData.auth != null) {
  tokenManager.restoreFromStorage(authData.auth!, authData.issuedAt!);
}

// 3. 로그아웃 시 삭제
await AuthStorage.clearAll();

// 4. 빠른 토큰 접근
final accessToken = await AuthStorage.loadAccessToken();
*/