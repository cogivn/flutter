import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'environment.dart';
import 'getit_utils.config.dart';

final getIt = GetIt.instance;

@injectableInit
void configureDependencies() => getIt.init(
      environment: EnvironmentBuilding.flavor,
    );

class GetItUtils {
  static setup() async => configureDependencies();
}
