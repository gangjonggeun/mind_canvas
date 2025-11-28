// =============================================================
// 📁 features/taro/domain/usecases/taro_use_case.dart
// =============================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/utils/result.dart';

import '../../data/dto/request/submit_taro_request.dart';
import '../models/TaroResultEntity.dart';
import '../repositories/taro_repository.dart';
import '../../data/repositories/taro_repository_impl.dart';

part 'taro_use_case.g.dart';

@riverpod
TaroUseCase taroUseCase(TaroUseCaseRef ref) {
  final repository = ref.watch(taroRepositoryProvider);
  return TaroUseCase(repository);
}

/// 🔮 타로 상담 비즈니스 로직 담당 UseCase
class TaroUseCase {
  final TaroRepository _repository;

  TaroUseCase(this._repository);

  /// 타로 상담 실행
  ///
  /// <p><strong>비즈니스 규칙:</strong></p>
  /// - 주제(Theme)는 비어있으면 안 됨
  /// - 선택한 스프레드 타입에 맞는 카드 개수가 정확해야 함
  /// - (예: 3카드 -> 3장, 켈틱크로스 -> 10장)
  Future<Result<TaroResultEntity>> analyzeTaro(SubmitTaroRequest request) async {
    try {
      print('🔮 [UseCase] 타로 상담 요청 시작 - Type: ${request.spreadType}');

      // 1. 비즈니스 규칙 검증 (정책적 유효성)
      final validationResult = _validateRequest(request);
      if (validationResult != null) {
        print('❌ [UseCase] 입력 검증 실패: ${validationResult.message}');
        return validationResult;
      }

      // 2. Repository 호출 (데이터 통신)
      final result = await _repository.analyzeTaro(request);

      // 3. 결과 처리 및 후가공
      return result.fold(
        onSuccess: (data) {
          print('✅ [UseCase] 타로 분석 성공 - ID: ${data.id}');
          // 필요하다면 여기서 로컬 DB에 저장하거나, 특정 문구를 가공할 수 있음
          return Result.success(data, '타로 상담이 완료되었습니다.');
        },
        onFailure: (message, errorCode) {
          print('❌ [UseCase] 타로 분석 실패: $message');

          // 사용자 친화적 메시지로 변환
          final userMessage = _convertToUserFriendlyMessage(errorCode?? 'UNKNOWN_ERROR', message);
          return Result.failure(userMessage, errorCode);
        },
      );
    } catch (e) {
      print('❌ [UseCase] 예상치 못한 오류: $e');
      return Result.failure(
        '상담 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
        'USECASE_ERROR',
      );
    }
  }

  /// 🛡️ 유효성 검사 로직
  Result<TaroResultEntity>? _validateRequest(SubmitTaroRequest request) {
    if (request.theme.trim().isEmpty) {
      return Result.failure('상담 주제를 입력해주세요.', 'VALIDATION_ERROR');
    }

    if (request.cards.isEmpty) {
      return Result.failure('선택된 카드가 없습니다.', 'VALIDATION_ERROR');
    }

    // 스프레드 타입별 카드 개수 검증 (서버로 보내기 전 입구 컷)
    int expectedCount = 0;
    switch (request.spreadType) { // 문자열이면 상수로 관리하는 것이 좋음
      case '3': // 혹은 "THREE_CARD"
        expectedCount = 3;
        break;
      case '5':
        expectedCount = 5;
        break;
      case '7':
        expectedCount = 7;
        break;
      case '10':
        expectedCount = 10;
        break;
      default:
      // 알 수 없는 타입은 일단 통과시키거나 에러 처리
        break;
    }

    if (expectedCount > 0 && request.cards.length != expectedCount) {
      return Result.failure(
        '${request.spreadType} 스프레드는 $expectedCount장의 카드가 필요합니다.',
        'CARD_COUNT_MISMATCH',
      );
    }

    return null; // 통과
  }

  /// 🗣️ 에러 메시지 변환
  String _convertToUserFriendlyMessage(String code, String originalMessage) {
    switch (code) {
      case 'AUTHENTICATION_EXPIRED':
        return '로그인이 만료되었습니다. 다시 로그인해주세요.';
      case 'NETWORK_DISCONNECTED':
        return '인터넷 연결이 불안정합니다.';
      case 'TOO_MANY_REQUESTS':
        return '잠시 후 다시 시도해주세요.';
      case 'SERVER_ERROR':
        return '서버 점검 중입니다. 잠시 후 이용해주세요.';
      default:
        return originalMessage; // 기본 메시지 반환
    }
  }
}