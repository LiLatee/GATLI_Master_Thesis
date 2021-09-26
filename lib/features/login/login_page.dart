import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_thesis/core/l10n/l10n.dart';
import 'package:master_thesis/features/home_page/home_screen.dart';
import 'package:master_thesis/features/login/login_cubit.dart';
import 'package:master_thesis/features/login/sign_in_widget.dart';
import 'package:master_thesis/features/login/sign_up_widget.dart';
import 'package:master_thesis/features/widgets/rounded_background_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String routeName = '/loginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginCubit loginCubit;

  @override
  void initState() {
    super.initState();
    loginCubit = LoginCubit();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
    );

    return BlocListener<LoginCubit, LoginState>(
      bloc: loginCubit,
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushNamed(context, HomePage.routeName);
        } else if (state is LoginError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Expanded(
                child: Column(
                  children: [
                    _buildTabs(context),
                    Expanded(
                      child: TabBarView(
                        children: [
                          SignInWidget(loginCubit: loginCubit),
                          SignUpWidget(loginCubit: loginCubit),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TabBar(
        unselectedLabelStyle: Theme.of(context).textTheme.bodyText2,
        labelStyle: Theme.of(context).textTheme.headline6,
        indicatorColor: Theme.of(context).colorScheme.primary,
        labelColor: Colors.black,
        tabs: [
          Tab(child: Text(context.l10n.signIn)),
          Tab(child: Text(context.l10n.signUp)),
        ],
      ),
    );
  }

  Stack _buildHeader(BuildContext context) {
    return Stack(
      children: [
        const RoundedBackgroundWidget(backgroundHeight: 214),
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const FlutterLogo(size: 77),
                  const SizedBox(height: 8),
                  Text(
                    'My App Name',
                    style: Theme.of(context).textTheme.headline4,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OrWidget extends StatelessWidget {
  const OrWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 20.0),
                child: const Divider(
                  color: Colors.black,
                  height: 36,
                ),
              ),
            ),
            Text(
              context.l10n.or,
              style: Theme.of(context).textTheme.headline6,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 20.0),
                child: const Divider(
                  color: Colors.black,
                  height: 36,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
