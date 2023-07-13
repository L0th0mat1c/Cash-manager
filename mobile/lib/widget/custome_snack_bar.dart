/* Flutter & Dart */
import 'package:flutter/material.dart';

/* External Widget */
import 'package:google_fonts/google_fonts.dart';

class CustomSnackBar extends StatefulWidget {
  final String message;
  final Widget icon;
  final Color backgroundColor;
  final TextStyle textStyle;
  final int iconRotationAngle;

  const CustomSnackBar.success({
    @required this.message,
    this.icon = const Icon(
      Icons.sentiment_very_satisfied,
      color: const Color(0x15000000),
      size: 120,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.iconRotationAngle = 32,
    this.backgroundColor = const Color(0xff00E676),
  });

  const CustomSnackBar.info({
    @required this.message,
    this.icon = const Icon(
      Icons.sentiment_neutral,
      color: const Color(0x15000000),
      size: 120,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.iconRotationAngle = 32,
    this.backgroundColor = const Color(0xff2196F3),
  });

  const CustomSnackBar.error({
    @required this.message,
    this.icon = const Icon(
      Icons.error_outline,
      color: const Color(0x15000000),
      size: 120,
    ),
    this.textStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: Colors.white,
    ),
    this.iconRotationAngle = 32,
    this.backgroundColor = const Color(0xffff5252),
  });

  @override
  _CustomSnackBarState createState() => _CustomSnackBarState();
}

class _CustomSnackBarState extends State<CustomSnackBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(
        top: 7,
        bottom: 7,
        left: 27,
        right: 27,
      ),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
      ),
      width: double.infinity,
      child: Center(
        child: Text(
          widget.message,
          style: theme.textTheme.bodyText2?.merge(
            GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
    );
  }
}
