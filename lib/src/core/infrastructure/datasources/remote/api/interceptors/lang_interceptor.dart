import 'dart:ui';

import 'package:dio/dio.dart';

import '../../../../../../common/extensions/locale_x.dart';
import '../../../../../domain/interfaces/lang_repository_interface.dart';
import '../base/api_path.dart';

class LangInterceptor extends QueuedInterceptorsWrapper {
  final ILangRepository _repository;

  LangInterceptor(this._repository);

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.method == ApiMethod.get) {
      options.queryParameters = update(
        data: options.queryParameters,
        update: _extras(),
      );
    } else if (options.data != null) {
      options.data = (options.data is FormData)
          ? options.data
          : (options.data is Map<String, dynamic>)
              ? update(data: options.data, update: _extras())
              : update(data: options.data.toJson(), update: _extras());
    }
    return super.onRequest(options, handler);
  }

  Map<String, dynamic> _extras() {
    Locale locale = _repository.getLocale();
    return {'lang': _prepareLangForApi(locale)};
  }

  /// Language (zh-hk: HongKong | zh-cn: Chinese | en: English)
  String _prepareLangForApi(Locale locale) {
    switch (locale.fullLanguageCode) {
      case 'zh_Hans':
        return 'zh-cn';
      case 'zh_Hant':
        return 'zh-hk';
      default:
        return 'en';
    }
  }

  Map<String, dynamic> update({
    required Map<String, dynamic> data,
    required Map<String, dynamic>? update,
  }) {
    if (update == null) return data;
    update.forEach((key, value) {
      data[key] = value;
    });
    return data;
  }
}
