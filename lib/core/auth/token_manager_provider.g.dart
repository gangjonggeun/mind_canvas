// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_manager_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tokenManagerHash() => r'b9e630e0a135d1ade8d121d9a5335eb032c22480';

/// 🏭 TokenManager 싱글톤 Provider
///
/// 앱 전체에서 하나의 TokenManager 인스턴스를 공유
/// 메모리 효율성을 위해 keepAlive 사용
///
/// Copied from [tokenManager].
@ProviderFor(tokenManager)
final tokenManagerProvider = Provider<TokenManager>.internal(
  tokenManager,
  name: r'tokenManagerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tokenManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TokenManagerRef = ProviderRef<TokenManager>;
String _$isLoggedInHash() => r'ff62aaaa4e64373bdac62723cd11e464c6296a5a';

/// See also [isLoggedIn].
@ProviderFor(isLoggedIn)
final isLoggedInProvider = AutoDisposeProvider<bool>.internal(
  isLoggedIn,
  name: r'isLoggedInProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isLoggedInHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsLoggedInRef = AutoDisposeProviderRef<bool>;
String _$canMakeApiCallHash() => r'968c5e3dc3b98154df272bceca688013f3cddeac';

/// See also [canMakeApiCall].
@ProviderFor(canMakeApiCall)
final canMakeApiCallProvider = AutoDisposeProvider<bool>.internal(
  canMakeApiCall,
  name: r'canMakeApiCallProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$canMakeApiCallHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CanMakeApiCallRef = AutoDisposeProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
