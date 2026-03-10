import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTopBar extends StatelessWidget {
  final String name;
  final VoidCallback onProfileTap;

  const HomeTopBar({super.key, required this.name, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_getGreetingText()},',
              style: GoogleFonts.outfit(
                color: const Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
            Text(
              name,
              style: GoogleFonts.outfit(
                color: const Color(0xFF111827),
                fontWeight: FontWeight.w800,
                fontSize: 28.sp,
                letterSpacing: -1,
              ),
            ),
          ],
        ),
        Container(
          height: 48.w,
          width: 48.w,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: IconButton(
            onPressed: onProfileTap,
            icon: const Icon(
              Icons.person_outline_rounded,
              color: Color(0xFF4B5563),
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  String _getGreetingText() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }
}
