import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:master_thesis/features/login/sign_in/email_sign_in/email_sign_in_cubit.dart';
import 'package:master_thesis/features/login/sign_in/email_sign_in/email_sign_in_page.dart';
import 'package:master_thesis/features/login/sign_up/email_sign_up/email_sign_up_page.dart';
import 'package:master_thesis/features/widgets/rounded_background_widget.dart';
import 'package:master_thesis/features/widgets/whole_screen_width_button.dart';
import 'package:master_thesis/service_locator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
      ),
    );

    return Scaffold(
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
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TabBar(
                      unselectedLabelStyle:
                          Theme.of(context).textTheme.bodyText2,
                      labelStyle: Theme.of(context).textTheme.headline6,
                      indicatorColor: Theme.of(context).colorScheme.primary,
                      labelColor: Colors.black,
                      onTap: (value) {
                        setState(() {
                          currentTabIndex = value;
                        });
                      },
                      tabs: const [
                        Tab(child: Text('Sign in')),
                        Tab(child: Text('Sign up')),
                      ],
                    ),
                  ),
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
    );
  }

  Widget _buildSignIn() {
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
                    labelText: 'Email address',
                    prefixIcon: Icon(Icons.email),
                  ),
                  SizedBox(height: 16),
                  InputField(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  OrWidget(context: context),
                  Row(
                    children: [
                      Expanded(
                        child: SignInButton(
                          Buttons.Google,
                          text: 'Sign in with Google',
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          WholeScreenWidthButton(
            label: 'Sign in',
            onPressed: () {},
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSignUp() {
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
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.account_circle_outlined),
                  ),
                  SizedBox(height: 16),
                  InputField(
                    labelText: 'Email address',
                    prefixIcon: Icon(Icons.email),
                  ),
                  SizedBox(height: 16),
                  InputField(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  OrWidget(context: context),
                  Row(
                    children: [
                      Expanded(
                        child: SignInButton(
                          Buttons.Google,
                          text: 'Sign up with Google',
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
          WholeScreenWidthButton(
            label: 'Sign up',
            onPressed: () {},
          ),
          const SizedBox(height: 16),
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

  Widget _buildOldPage(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign up!'),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text('Meet Up',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontFamily: 'Roboto')),
                ),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SignInButton(
                      Buttons.Email,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      elevation: 5,
                      text: 'Sign up with Email',
                      onPressed: () =>
                          Navigator.pushNamed(context, EmailSignUp.routeName),
                    )),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SignInButton(
                    Buttons.Google,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(
                            20))), // not working with flutter_signin_button: ^2.0.0
                    elevation: 5,
                    text: 'Sign up with Google',
                    onPressed: () {},
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                        child: const Text('Log In Using Email',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                      create: (context) =>
                                          sl<EmailSignInCubit>(),
                                      child: EmailSignInPage(),
                                    )),
                          );
                        }))
              ]),
        ));
  }
}

class OrWidget extends StatelessWidget {
  const OrWidget({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

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
              'or',
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
  }) : super(key: key);

  final String labelText;
  final Icon prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      // onChanged: (email) => context.read<SignInBloc>().add(SignInEmailChanged(email)),
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
