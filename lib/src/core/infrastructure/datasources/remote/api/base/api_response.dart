import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../../../common/extensions/locale_x.dart';
import '../../../../../../common/utils/getit_utils.dart';
import '../../../../../domain/errors/api_error.dart';
import '../../../../../domain/interfaces/lang_repository.dart';

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

@freezed
abstract class MessageContent with _$MessageContent {
  const factory MessageContent({
    String? en,
    @JsonKey(name: 'tc') String? tc,
  }) = _MessageContent;

  factory MessageContent.fromJson(Map<String, dynamic> json) =>
      _$MessageContentFromJson(json);
}

@freezed
abstract class ResultData with _$ResultData {
  const factory ResultData({
    required int code,
    required String message,
    @JsonKey(name: 'message_content') MessageContent? messageContent,
    String? action,
  }) = _ResultData;

  factory ResultData.fromJson(Map<String, dynamic> json) =>
      _$ResultDataFromJson(json);
}

@Freezed(genericArgumentFactories: true)
abstract class SingleApiResponse<T> with _$SingleApiResponse<T> {
  const SingleApiResponse._();

  const factory SingleApiResponse({
    required T data,
    required ResultData result,
  }) = _SingleApiResponse;

  factory SingleApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$SingleApiResponseFromJson(json, fromJsonT);

  /// Gets the localized error message based on the current locale
  String? getLocalizedMessageFromCurrentLocale() {
    final langRepo = getIt<LangRepository>();
    final languageCode = langRepo.getLocale().fullLanguageCode;
    return getLocalizedMessage(languageCode);
  }

  /// Gets the localized error message based on the provided language code
  String? getLocalizedMessage(String languageCode) {
    // If no message content exists or we're using a language code other than zh_Hant,
    // return either the English message or fall back to the default message
    return result.messageContent == null
        ? result.message
        : languageCode == 'zh_Hant'
        ? result.messageContent?.tc ?? result.message
        : result.messageContent?.en ?? result.message;
  }
}

@freezed
abstract class NoDataApiResponse with _$NoDataApiResponse {
  const NoDataApiResponse._();

  const factory NoDataApiResponse({
    required ResultData result,
  }) = _NoDataApiResponse;

  factory NoDataApiResponse.fromJson(Map<String, dynamic> json) =>
      _$NoDataApiResponseFromJson(json);

  /// Gets the localized error message based on the current locale
  String? getLocalizedMessageFromCurrentLocale() {
    final langRepo = getIt<LangRepository>();
    final languageCode = langRepo.getLocale().fullLanguageCode;
    return getLocalizedMessage(languageCode);
  }

  /// Gets the localized error message based on the provided language code
  String? getLocalizedMessage(String languageCode) {
    // If no message content exists or we're using a language code other than zh_Hant,
    // return either the English message or fall back to the default message
    return result.messageContent == null
        ? result.message
        : languageCode == 'zh_Hant'
        ? result.messageContent?.tc ?? result.message
        : result.messageContent?.en ?? result.message;
  }
}

@Freezed(genericArgumentFactories: true)
abstract class ListApiResponse<T> with _$ListApiResponse<T> {
  const ListApiResponse._();
  const factory ListApiResponse({
    @Default('') String ut,
    @Default([]) List<T> data,
  }) = _ListApiResponse;

  factory ListApiResponse.fromJson(
      Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$ListApiResponseFromJson(json, fromJsonT);

  /// Gets the update time in ISO 8601 format
  String get isoTimestamp => ut.isEmpty ? '' : ut.replaceFirst(' ', 'T');
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
