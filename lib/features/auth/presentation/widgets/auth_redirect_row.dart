import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthRedirectRow extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;

  const AuthRedirectRow({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: GoogleFonts.outfit(
            color: isDark ? Colors.white54 : const Color(0xFF6B7280),
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            linkText,
            style: GoogleFonts.outfit(
              color: const Color(0xFF059669),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
