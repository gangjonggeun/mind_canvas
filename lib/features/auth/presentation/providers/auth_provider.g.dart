// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isAuthenticatedHash() => r'bb77c47cd47dcd5e7e2b3ef11c052dcd62643bfc';

/// 🎯 인증 상태 확인 Providers
///
/// Copied from [isAuthenticated].
@ProviderFor(isAuthenticated)
final isAuthenticatedProvider = AutoDisposeProvider<bool>.internal(
  isAuthenticated,
  name: r'isAuthenticatedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAuthenticatedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsAuthenticatedRef = AutoDisposeProviderRef<bool>;
String _$currentUserHash() => r'491a0526425005b25c18e0b71bffe87f159ed5f4';

/// See also [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeProvider<AuthUser?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = AutoDisposeProviderRef<AuthUser?>;
String _$isLoadingHash() => r'2ad7e67a250729d9ff3401b95d466527a1d3ccd2';

/// See also [isLoading].
@ProviderFor(isLoading)
final isLoadingProvider = AutoDisposeProvider<bool>.internal(
  isLoading,
  name: r'isLoadingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsLoadingRef = AutoDisposeProviderRef<bool>;
String _$needsNicknameHash() => r'fa82eb10e902efdf45763d3d04e1b5a976b9128a';

/// See also [needsNickname].
@ProviderFor(needsNickname)
final needsNicknameProvider = AutoDisposeProvider<bool>.internal(
  needsNickname,
  name: r'needsNicknameProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$needsNicknameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NeedsNicknameRef = AutoDisposeProviderRef<bool>;
String _$isAnonymousUserHash() => r'f4d143feb78de88920d5bf085f9b7e8f332c7d1d';

/// See also [isAnonymousUser].
@ProviderFor(isAnonymousUser)
final isAnonymousUserProvider = AutoDisposeProvider<bool>.internal(
  isAnonymousUser,
  name: r'isAnonymousUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isAnonymousUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsAnonymousUserRef = AutoDisposeProviderRef<bool>;
String _$isSocialUserHash() => r'c4ff663fda5287118c4fa48444b9e6c792cdcd6f';

/// See also [isSocialUser].
@ProviderFor(isSocialUser)
final isSocialUserProvider = AutoDisposeProvider<bool>.internal(
  isSocialUser,
  name: r'isSocialUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isSocialUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsSocialUserRef = AutoDisposeProviderRef<bool>;
String _$authNotifierHash() => r'a46a5b245b8288c52fdab4d564dd479b0282122d';

/// 🔐 인증 상태 관리 Provider
///
/// Copied from [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AuthNotifier, AuthUser?>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthNotifier = AutoDisposeAsyncNotifier<AuthUser?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
