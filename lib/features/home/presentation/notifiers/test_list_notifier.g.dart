// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$testListNotifierHash() => r'44cfb66063115a3822adc11222e69b1da8c025ac';

/// 🧠 테스트 목록 상태 관리 (전체 API 지원)
///
/// 서버의 모든 테스트 목록 API를 지원하는 통합 노티파이어
/// 메모리 효율성을 위한 페이징 및 무한 스크롤 지원
///
/// Copied from [TestListNotifier].
@ProviderFor(TestListNotifier)
final testListNotifierProvider =
    AutoDisposeNotifierProvider<TestListNotifier, TestListState>.internal(
  TestListNotifier.new,
  name: r'testListNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$testListNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TestListNotifier = AutoDisposeNotifier<TestListState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
