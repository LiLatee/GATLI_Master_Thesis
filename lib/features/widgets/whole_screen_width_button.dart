import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// TODO use testStyles from Theme
// TODO use colors from Theme
class WholeScreenWidthButton extends StatelessWidget {
  const WholeScreenWidthButton(
      {Key? key, required this.label, required this.onPressed})
      : super(key: key);

  final String label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              primary: Colors.white,
              textStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.25,
                  ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              fixedSize: const Size(double.infinity, 48),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
