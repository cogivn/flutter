import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request.freezed.dart';
part 'login_request.g.dart';

@freezed
abstract class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    @Default('') String email,
    @Default('') String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(dynamic json) => _$LoginRequestFromJson(json);
}
