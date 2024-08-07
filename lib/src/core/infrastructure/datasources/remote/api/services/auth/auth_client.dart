import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../../../modules/auth/infrastructure/dtos/user_dto.dart';
import '../../base/api_response.dart';
import 'models/login_request.dart';
import 'models/login_response.dart';

part 'auth_client.g.dart';

@RestApi()
@injectable
abstract class AuthClient {
  @factoryMethod
  factory AuthClient(Dio dio) = _AuthClient;

  @GET('/login')
  Future<SingleApiResponse<LoginResponse>> login(
    @Body() LoginRequest request,
    @CancelRequest() CancelToken? cancelToken,
  );

  @GET('/login_failed')
  Future<SingleApiResponse<LoginResponse>> loginFailed(
    @CancelRequest() CancelToken? cancelToken,
  );

  @GET('/user')
  Future<ListApiResponse<UserDTO>> users(
      @CancelRequest() CancelToken? cancelToken);

  @GET('/user/{id}')
  Future<SingleApiResponse<UserDTO>> user(
    @Path('id') String id,
    @CancelRequest() CancelToken? cancelToken,
  );
}
