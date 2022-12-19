import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    @JsonKey(name: 'access_token') @Default('') String accessToken,
  }) = _AuthResponse;

  const AuthResponse._();

  factory AuthResponse.fromJson(json) => _$AuthResponseFromJson(json);
}
