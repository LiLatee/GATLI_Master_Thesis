import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:master_thesis/core/l10n/l10n.dart';
import 'package:master_thesis/features/login/login_cubit.dart';
import 'package:master_thesis/features/login/login_page.dart';
import 'package:master_thesis/features/widgets/input_field.dart';
import 'package:master_thesis/features/widgets/whole_screen_width_button.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({
    Key? key,
    required this.loginCubit,
  }) : super(key: key);

  final LoginCubit loginCubit;

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final emailFormKey = GlobalKey<FormState>();
    final passwordFormKey = GlobalKey<FormState>();

    return BlocBuilder<LoginCubit, LoginState>(
      bloc: loginCubit,
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
                        errorMessage: 'Please provide correct email address.',
                        formKey: emailFormKey,
                        isEmail: true,
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        labelText: context.l10n.password,
                        obscure: true,
                        prefixIcon: const Icon(Icons.lock_outline),
                        textEditingController: passwordController,
                        errorMessage: "Password can't be empty.",
                        formKey: passwordFormKey,
                      ),
                      const OrWidget(),
                      Row(
                        children: [
                          Expanded(
                            child: SignInButton(
                              Buttons.Google,
                              text: context.l10n.signInGoogle,
                              onPressed: () async {
                                await loginCubit.signInWithGoogle(
                                    context: context); // TODO check on iOS
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
                    final bool allFieldsFilled =
                        (emailFormKey.currentState!.validate()) &&
                            (passwordFormKey.currentState!.validate());

                    if (allFieldsFilled) {
                      loginCubit.login(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                    }
                  },
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
