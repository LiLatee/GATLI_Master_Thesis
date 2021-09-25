// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_thesis/features/login/sign_in/email_sign_in/email_sign_in_cubit.dart';

// class EmailSignInPage extends StatefulWidget {
//   @override
//   _EmailSignInPageState createState() => _EmailSignInPageState();
// }

// class _EmailSignInPageState extends State<EmailSignInPage> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   late final EmailSignInCubit emailSignInCubit;

//   @override
//   void initState() {
//     super.initState();
//     emailSignInCubit = EmailSignInCubit();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: BlocConsumer<EmailSignInCubit, EmailSignInState>(
//         bloc: emailSignInCubit,
//         listener: (context, state) {
//           if (state is EmailSignInErrorState)
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(SnackBar(content: Text(state.error)));
//         },
//         builder: (context, state) {
//           if (state is EmailLoggedInState) {
//             return Center(
//               child: Container(
//                 child: const Text('Zalogowano! :) '),
//               ),
//             );
//           } else {
//             return _loginForm(context: context, state: state);
//           }
//         },
//       ),
//     );
//   }

//   Form _loginForm({
//     required BuildContext context,
//     required EmailSignInState state,
//   }) {
//     return Form(
//       key: _formKey,
//       child: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: TextFormField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Enter Email Address',
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//                 // The validator receives the text that the user has entered.
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Enter Email Address';
//                   } else if (!value.contains('@')) {
//                     return 'Please enter a valid email address!';
//                   }
//                   return null;
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: TextFormField(
//                 obscureText: true,
//                 controller: passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'Enter Password',
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//                 // The validator receives the text that the user has entered.
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Enter Password';
//                   } else if (value.length < 6) {
//                     return 'Password must be atleast 6 characters!';
//                   }
//                   return null;
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: ElevatedButton(
//                 style: ButtonStyle(
//                     backgroundColor:
//                         MaterialStateProperty.all<Color>(Colors.lightBlue)),
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     emailSignInCubit.login(
//                       email: emailController.text,
//                       password: passwordController.text,
//                     );
//                   }
//                 },
//                 child: const Text('Submit'),
//               ),
//             ),
//             if (state is EmailLoggingState)
//               const Center(
//                 child: CircularProgressIndicator(),
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }
