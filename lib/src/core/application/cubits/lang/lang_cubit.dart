import 'dart:ui';

import 'package:injectable/injectable.dart';
import 'package:riverbloc/riverbloc.dart';

import '../../../../common/extensions/locale_x.dart';
import '../../../../common/utils/getit_utils.dart';
import '../../../../common/utils/logger.dart';
import '../../../domain/interfaces/lang_repository.dart';

final langProvider = BlocProvider<LangCubit, Locale>((_) => getIt<LangCubit>());

@singleton
class LangCubit extends Cubit<Locale> {
  LangCubit(this._repository) : super(_repository.getLocale());

  final LangRepository _repository;

  void setLocale(Locale val) async {
    if (val == _repository.getLocale()) return;

    try {
      await _repository.setLocale(val);
      logger.d('currentLocale - ${val.fullLanguageCode}');
      emit(val);
    } catch (error) {
      logger.e(error);
    }
  }
}
