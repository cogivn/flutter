import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../common/extensions/build_context_x.dart';

part '../widgets/auth_body.dart';
part '../widgets/email_widget.dart';
part '../widgets/password_widget.dart';

@RoutePage()
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: const AuthBody(),
      ),
    );
  }
}
