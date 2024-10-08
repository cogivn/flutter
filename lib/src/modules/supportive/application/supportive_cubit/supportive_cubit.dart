import 'package:bloc/bloc.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../common/mixin/safe_bloc_base.dart';
import '../../../../core/domain/errors/api_error.dart';
import '../../domain/repositories/supportive_repository.dart';

part 'supportive_cubit.freezed.dart';
part 'supportive_state.dart';

@injectable
class SupportiveCubit extends Cubit<SupportiveState> with SafeBlocBase {
  final SupportiveRepository _repository;
  final String slug;

  SupportiveCubit(
    @factoryParam this.slug,
    this._repository,
  ) : super(const _Loading()) {
    get();
  }

  get() async {
    emit(const _Loading());
    await Future.delayed(1.seconds);
    emit(await _repository.getSupportive(slug).fold(
          (s) => state.onLoaded(s),
          (f) => state.onError(f),
        ));
  }
}
