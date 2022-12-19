import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../common/extensions/int_duration.dart';
import '../../../../common/utils/environment.dart';
import '../../../../core/infrastructure/datasources/local/storage.dart';
import '../../../../core/infrastructure/datasources/remote/api/api_client.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_error.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_path.dart';
import '../../../../core/infrastructure/datasources/remote/api/base/api_response.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/models/login_request.dart';
import '../../../../core/infrastructure/datasources/remote/api/services/auth/models/register_request.dart';
import '../../domain/entities/user.dart';
import '../../domain/interfaces/auth_repository_interface.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

@alpha
@LazySingleton(as: IAuthRepository)
class AuthRepository implements IAuthRepository {
  final ApiClient _client;

  AuthRepository(this._client);

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
    final json = (request.password == 'aA12345@')
        ? _FakeAuthService.authenticated
        : _FakeAuthService.unauthenticated;
    final response = await _client.request(
      data: request.toJson(),
      cancelToken: token,
      path: 'login',
      method: ApiMethod.get,
      fromJsonT: (_) => AuthResponse.fromJson(jsonDecode(json)),
    );
    return response.fold((l) => left(l), (r) async {
      setAccessToken(r.accessToken);
      final userRes = await me();
      return userRes.fold((l) => left(l), (r) => right(r));
    });
  }

  @override
  Future<Either<ApiError, User>> me({CancelToken? token}) async {
    final json = jsonDecode(_FakeAuthService.me);
    final response = SingleApiResponse.fromJson(
      fromJsonT: UserModel.fromJson,
      json: json,
    );
    return right(response.data);
  }

  @override
  Future<Either<ApiError, User>> register(RegisterRequest request,
      {CancelToken? token}) async {
    final json = _FakeAuthService.authenticated;
    final response = await _client.request(
        data: request.toJson(),
        cancelToken: token,
        path: 'login',
        method: ApiMethod.get,
        fromJsonT: (_) => AuthResponse.fromJson(jsonDecode(json)));
    return response.fold((l) => left(l), (r) async {
      setAccessToken(r.accessToken);
      final userRes = await me();
      return userRes.fold((l) => left(l), (r) => right(r));
    });
  }

  @override
  Future logout() async {
    await Future.delayed(1.seconds);
    await setUser(null);
    await setAccessToken(null);
  }
}

class _FakeAuthService {
  static String get authenticated => '''
  {
    "message": "OK",
    "server_time": "2022-12-09T03:55:50.719Z",
    "access_token": "34xp4vRoCGJym3xR7yCVPFHoCNxv4Twseo"
  }
  ''';

  static String get me => '''
  {
    "message": "OK",
    "server_time": "2022-12-08T14:51:34.514Z",
    "data": {
      "first_name": "Cody",
      "avatar": "https://thuthuatnhanh.com/wp-content/uploads/2022/06/Anh-Wibu-doi-non-gau.jpg",
      "last_name": "Beahan",
      "email": "Petra.Dare@hotmail.com",
      "district_id": 1,
      "gender": 0,
      "age_group": 27,
      "phone_no": "793.480.7855 x0890",
      "birthday": "2003-09-11T11:37:12.926Z",
      "created_at": "2022-01-06T20:53:21.716Z",
      "member_no": 74594,
      "membership_name": "Member Investment",
      "point": 21730,
      "spending": 50,
      "expired_at": "2023-02-14T01:12:03.059Z",
      "min": 5,
      "max": 93
    }
  }
  ''';

  static String get unauthenticated => '''
  {
    "data": null,
    "error": {
      "code": 404,
      "message": "Cannot find any user with this email & password!"
    },
    "message": "Cannot find any user with this email & password!"
  }
  ''';
}
