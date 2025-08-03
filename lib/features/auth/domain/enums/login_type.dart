enum LoginType {
  google,
  apple,
  guest;

  String get displayName => switch (this) {
    LoginType.google => 'Google',
    LoginType.apple => 'Apple',
    LoginType.guest => 'Guest',
  };
}