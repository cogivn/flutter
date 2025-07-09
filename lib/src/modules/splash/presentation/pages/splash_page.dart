import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import '../../../../common/utils/app_environment.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Welcome to ${AppEnvironment.flavor}')),
    );
  }
}
