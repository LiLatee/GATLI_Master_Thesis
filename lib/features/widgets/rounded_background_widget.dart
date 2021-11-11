import 'package:flutter/material.dart';

class RoundedBackgroundWidget extends StatelessWidget {
  const RoundedBackgroundWidget({
    Key? key,
    required this.backgroundHeight,
  }) : super(key: key);
  final double backgroundHeight;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurveClipper(),
      child: Container(
        height: backgroundHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryVariant,
              Theme.of(context).colorScheme.primary,
            ],
          ),
        ),
      ),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const curveHeight = 38;
    final controlPoint = Offset(size.width / 2, size.height + curveHeight);
    final endPoint = Offset(size.width, size.height - curveHeight);

    final path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
