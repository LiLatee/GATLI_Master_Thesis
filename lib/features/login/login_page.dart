import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:master_thesis/core/l10n/l10n.dart';
import 'package:master_thesis/features/home_page/home_screen.dart';
import 'package:master_thesis/features/login/login_cubit.dart';
import 'package:master_thesis/features/widgets/rounded_background_widget.dart';
import 'package:master_thesis/features/widgets/whole_screen_width_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const String routeName = '/loginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginCubit loginCubil;

  @override
  void initState() {
    super.initState();
    loginCubil = LoginCubit();
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
      bloc: loginCubil,
      listener: (context, state) {
        if (state is LoginSuccess) {
          log('sds?');
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
                          _buildSignIn(),
                          _buildSignUp(),
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

  Widget _buildSignIn() {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return BlocBuilder<LoginCubit, LoginState>(
      bloc: loginCubil,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InputField(
                        labelText: context.l10n.email,
                        prefixIcon: const Icon(Icons.email),
                        textEditingController: emailController,
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        labelText: context.l10n.password,
                        obscure: true,
                        prefixIcon: const Icon(Icons.lock_outline),
                        textEditingController: passwordController,
                      ),
                      const OrWidget(),
                      Row(
                        children: [
                          Expanded(
                            child: SignInButton(
                              Buttons.Google,
                              text: context.l10n.signInGoogle,
                              onPressed: () async {
                                await signInWithGoogle(
                                    context: context); // TODO not working
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (state is LoginLoading)
                const CircularProgressIndicator()
              else
                WholeScreenWidthButton(
                  label: context.l10n.signIn,
                  onPressed: () async {
                    loginCubil.login(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                  },
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        log(user!.uid.toString());
      } on FirebaseAuthException catch (e, s) {
        log('error2: $e');
        log('stack2: $s');
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e, s) {
        log('error1: $e');
        log('stack1: $s');

        // handle the error here
      }
    }

    return user;
  }

  Widget _buildSignUp() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return BlocBuilder<LoginCubit, LoginState>(
      bloc: loginCubil,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InputField(
                        labelText: context.l10n.name,
                        prefixIcon: const Icon(Icons.account_circle_outlined),
                        textEditingController: nameController,
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        labelText: context.l10n.email,
                        prefixIcon: const Icon(Icons.email),
                        textEditingController: emailController,
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        labelText: context.l10n.password,
                        obscure: true,
                        prefixIcon: const Icon(Icons.lock_outline),
                        textEditingController: passwordController,
                      ),
                      const OrWidget(),
                      Row(
                        children: [
                          Expanded(
                            child: SignInButton(
                              Buttons.Google,
                              text: context.l10n.signUpGoogle,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (state is LoginLoading)
                const CircularProgressIndicator()
              else
                WholeScreenWidthButton(
                  label: context.l10n.signUp,
                  onPressed: () {
                    loginCubil.signUp(
                      email: emailController.text,
                      password: passwordController.text,
                      nickname: nameController.text,
                    );
                  },
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
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

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    this.obscure = false,
    this.textInputAction = TextInputAction.next,
    required this.textEditingController,
  }) : super(key: key);

  final String labelText;
  final Icon prefixIcon;
  final bool obscure;
  final TextInputAction textInputAction;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: textInputAction,
      controller: textEditingController,
      obscureText: obscure,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(16),
          child: prefixIcon,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.background,
        labelText: labelText,
        // errorText: state.email.invalid ? 'Email address is required.' : null,
      ),
    );
  }
}
