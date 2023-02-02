import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../common/extensions/int_duration.dart';
import '../../../../common/utils/app_environment.dart';
import '../../../../core/infrastructure/datasources/local/storage.dart';
import '../../../../core/infrastructure/datasources/remote/api/api_client.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/models/login_request.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/models/register_request.dart';
import '../../domain/entities/user.dart';
import '../../domain/interfaces/auth_repository_interface.dart';

@LazySingleton(as: IAuthRepository, env: AppEnvironment.environments)
class AuthRepositoryImpl implements IAuthRepository {
  // ignore: unused_field
  final ApiClient _client;

  AuthRepositoryImpl(this._client);

  @override
  User? getUser() => Storage.user;

  @override
  Future setUser(User? val) async => Storage.setUser(val);

  @override
  Future<String?> getAccessToken() => Storage.accessToken;

  @override
  Future setAccessToken(String? val) => Storage.setAccessToken(val);

  @override
  Future<Either<ApiError, User>> login(
    LoginRequest request, {
    CancelToken? token,
  }) async {
    // TODO: implement me
    throw UnimplementedError();
  }

  @override
  Future<Either<ApiError, User>> me({CancelToken? token}) {
    // TODO: implement me
    throw UnimplementedError();
  }

  @override
  Future<Either<ApiError, User>> register(RegisterRequest request,
      {CancelToken? token}) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future logout() async {
    await Future.delayed(1.seconds);
    await setUser(null);
    await setAccessToken(null);
  }
}
