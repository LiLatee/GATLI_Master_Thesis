import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_thesis/features/login/sign_up/email_sign_up/email_sign_up_cubit.dart';

class EmailSignUp extends StatefulWidget {
  static const String routeName = '/emailSingUpPage';

  @override
  _EmailSignUpState createState() => _EmailSignUpState();
}

class _EmailSignUpState extends State<EmailSignUp> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  late final EmailSignUpCubit emailSignUpCubit;

  @override
  void initState() {
    super.initState();
    emailSignUpCubit = EmailSignUpCubit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: BlocConsumer<EmailSignUpCubit, EmailSignUpState>(
        bloc: emailSignUpCubit,
        listener: (context, state) {
          if (state is EmailSignUpErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is EmailSignUpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign up success!')));
          }
        },
        builder: (context, state) {
          if (state is EmailSignUpInitial) {
            return _buildForm();
          } else if (state is EmailSignUpSuccess) {
            return Container(
              child: const Text('HOME PAGE'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Form _buildForm() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Enter User Name',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter User Name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Enter Email',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter an Email Address';
                } else if (!value.contains('@')) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: ageController,
              decoration: InputDecoration(
                labelText: 'Enter Age',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Age';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Enter Password',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Password';
                } else if (value.length < 6) {
                  return 'Password must be atleast 6 characters!';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.lightBlue)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        // registerToFb();
                        emailSignUpCubit.signUp(
                          email: emailController.text,
                          password: passwordController.text,
                          nickname: nameController.text,
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
          )
        ])));
  }

  // void registerToFb() {
  //   firebaseAuth
  //       .createUserWithEmailAndPassword(
  //           email: emailController.text, password: passwordController.text)
  //       .then((result) {
  //     dbRef.child(result.user!.uid).set({
  //       "email": emailController.text,
  //       "age": ageController.text,
  //       "name": nameController.text
  //     }).then((res) {
  //       isLoading = false;
  //       // TODO
  //       // Navigator.pushReplacement(
  //       //   context,
  //       //   MaterialPageRoute(builder: (context) => Home(uid: result.user!.uid)),
  //       // );
  //     });
  //   }).catchError((err) {
  //     showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text("Error"),
  //             content: Text(err.message),
  //             actions: [
  //               TextButton(
  //                 child: Text("Ok"),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               )
  //             ],
  //           );
  //         });
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    ageController.dispose();
  }
}
