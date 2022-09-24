import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constants/constants.dart';
import '../../../../common/extensions/build_context_x.dart';
import '../../../../core/application/cubits/auth_cubit/auth/auth_cubit.dart';
import '../../../app/app_router.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) => state.maybeWhen(
              orElse: () => Text(context.s.error_unexpected),
              authenticated: (user) => CircleAvatar(
                backgroundImage: NetworkImage(user.avatar),
                radius: 100,
              ),
            ),
          ),
          const SizedBox(height: Constants.spacing),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) => state.maybeWhen(
                orElse: () => Text(context.s.error_unexpected),
                authenticated: (user) => Text(context.s.hello(user.name),
                    textAlign: TextAlign.center,
                    style: context.textTheme.headline4)),
          ),
          const SizedBox(height: Constants.superFarPadding),
          ElevatedButton(
            onPressed: () => context.router.push(const CounterRoute()),
            child: Text(context.s.counter),
          ),
          const SizedBox(height: Constants.padding),
          ElevatedButton(
            onPressed: () => context.router.push(const SettingsRoute()),
            child: Text(context.s.settings),
          ),
        ],
      ),
    );
  }
}
