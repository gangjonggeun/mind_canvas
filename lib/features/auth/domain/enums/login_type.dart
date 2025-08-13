
import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(valueField: 'value')
enum LoginType {
  @JsonValue('GOOGLE')
  google('GOOGLE'),

  @JsonValue('APPLE')
  apple('APPLE'),

  @JsonValue('GUEST')
  guest('GUEST');

  const LoginType(this.value);
  final String value;
}