import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TaskActionFab extends StatelessWidget {
  final VoidCallback onTap;

  const TaskActionFab({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
          height: 64.w,
          width: 64.w,
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF059669).withValues(alpha: 0.25),
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        )
        .animate()
        .scale(delay: 400.ms, curve: Curves.easeOutBack)
        .shimmer(delay: 2.seconds, duration: 2.seconds, color: Colors.white24);
  }
}
