import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.labelText,
    required this.prefixIcon,
    this.obscure = false,
    this.textInputAction = TextInputAction.next,
    required this.textEditingController,
    this.errorMessage,
    this.formKey,
    this.isEmail = false,
  })  : assert((errorMessage == null && formKey == null) ||
            (errorMessage != null && formKey != null)),
        super(key: key);

  final String labelText;
  final Icon prefixIcon;
  final bool obscure;
  final TextInputAction textInputAction;
  final TextEditingController textEditingController;
  final String? errorMessage;
  final GlobalKey<FormState>? formKey;
  final bool isEmail;

  @override
  Widget build(BuildContext context) {
    final FormFieldValidator<String>? validator;
    if (isEmail) {
      validator = (value) {
        if (value == null || value.isEmpty || !EmailValidator.validate(value)) {
          return errorMessage;
        }
        return null;
      };
    } else {
      validator = (value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        return null;
      };
    }
    return Form(
      key: formKey,
      child: TextFormField(
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
        validator: validator,
      ),
    );
  }
}
