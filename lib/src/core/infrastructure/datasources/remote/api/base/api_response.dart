import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../../domain/errors/api_error.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

abstract class GenericObject<T> {
  T Function(Map<String, dynamic>) fromJsonT;

  GenericObject(this.fromJsonT);

  T genericObject(dynamic data) {
    return fromJsonT(data);
  }
}

class ResponseWrapper<T> extends GenericObject<T> {
  late T response;

  ResponseWrapper(super.fromJsonT);

  factory ResponseWrapper.init(
      {required T Function(Map<String, dynamic>) fromJsonT,
      required dynamic data}) {
    final wrapper = ResponseWrapper<T>(fromJsonT);
    wrapper.response = wrapper.genericObject(data);
    return wrapper;
  }
}

@freezed
abstract class ApiResponse with _$ApiResponse {
  const factory ApiResponse(ApiError? error, String message) = _ApiResponse;

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
}

@Freezed(genericArgumentFactories: true)
abstract class SingleApiResponse<T> with _$SingleApiResponse<T> {
  const factory SingleApiResponse(T data) = _SingleApiResponse;

  factory SingleApiResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$SingleApiResponseFromJson(json, fromJsonT);
}

@Freezed(genericArgumentFactories: true)
abstract class ListApiResponse<T> with _$ListApiResponse<T> {
  const factory ListApiResponse(List<T> data) = _ListApiResponse;

  factory ListApiResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$ListApiResponseFromJson(json, fromJsonT);
}

@Freezed(genericArgumentFactories: true)
abstract class PagingApiResponse<T> with _$PagingApiResponse<T> {
  const factory PagingApiResponse({
    required List<T> data,
    required int page,
    required int total,
  }) = _PagingApiResponse;

  factory PagingApiResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$PagingApiResponseFromJson(json, fromJsonT);
}

extension FoldedSingleApiResponse<T extends Object>
    on ResultDart<SingleApiResponse<T>, ApiError> {
  ResultDart<T, ApiError> get folded => fold(
        (success) => Success(success.data),
        (failure) => Failure(failure),
      );
}

extension FoldedListApiResponse<T extends Object>
    on ResultDart<ListApiResponse<T>, ApiError> {
  ResultDart<List<T>, ApiError> get folded => fold(
        (success) => Success(success.data),
        (failure) => Failure(failure),
      );
}
