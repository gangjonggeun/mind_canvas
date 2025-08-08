// lib/core/auth/providers/google_oauth_provider.dart (진짜 최종 완성본)

// ✅ Ref 타입을 알기 위해 반드시 필요합니다!
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/google/google_oauth_service.dart';

part 'google_oauth_provider.g.dart';

@riverpod
GoogleOAuthService googleOAuthService(Ref ref) {
  return GoogleOAuthService();
}