import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/models/login_request.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/models/register_request.dart';
import '../entities/user.dart';

abstract class IAuthRepository {
  User? getUser();

  Future setUser(User? val);

  Future<Either<ApiError, User>> register(
    RegisterRequest request, {
    CancelToken? token,
  });

  Future<Either<ApiError, User>> login(
    LoginRequest request, {
    CancelToken? token,
  });

  Future<Either<ApiError, User>> me({CancelToken? token});

  Future<String?> getAccessToken();

  Future setAccessToken(String? val);

  Future logout();
}
