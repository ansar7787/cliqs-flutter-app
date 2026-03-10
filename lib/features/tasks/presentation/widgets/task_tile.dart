import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/task_entity.dart';

class TaskTile extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Dismissible(
        key: Key(task.id),
        direction: task.isCompleted
            ? DismissDirection
                  .endToStart // Only delete for finished tasks
            : DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            onEdit();
            return false; // Snap back after triggering edit
          } else {
            onDelete();
            return true; // Dismiss for delete
          }
        },
        background: _buildSwipeBackground(
          alignment: Alignment.centerLeft,
          color: const Color(0xFF3B82F6), // Azure Blue
          icon: Icons.edit_note_rounded,
          padding: EdgeInsets.only(left: 30.w),
        ),
        secondaryBackground: _buildSwipeBackground(
          alignment: Alignment.centerRight,
          color: const Color(0xFFEF4444), // Crimson Red
          icon: Icons.delete_forever_rounded,
          padding: EdgeInsets.only(right: 30.w),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: task.isCompleted
                        ? 0.45
                        : 0.85, // Deeper fade for done
                  ),
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    color: task.isCompleted
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    if (!task.isCompleted)
                      Positioned(
                        left: -20,
                        top: -20,
                        child:
                            Container(
                                  width: 60.w,
                                  height: 60.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(
                                      0xFF10B981,
                                    ).withValues(alpha: 0.15),
                                  ),
                                )
                                .animate(onPlay: (c) => c.repeat(reverse: true))
                                .scale(
                                  duration: 2.seconds,
                                  begin: const Offset(1, 1),
                                  end: const Offset(1.5, 1.5),
                                ),
                      ),
                    InkWell(
                      onTap: onToggle,
                      onLongPress: task.isCompleted
                          ? null
                          : onEdit, // Disable edit if done
                      borderRadius: BorderRadius.circular(30.r),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
                        child: Row(
                          children: [
                            _buildCheckbox(context),
                            SizedBox(width: 18.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: GoogleFonts.outfit(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w800,
                                      color: task.isCompleted
                                          ? const Color(
                                              0xFF9CA3AF,
                                            ).withValues(alpha: 0.8)
                                          : const Color(0xFF111827),
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  if (task.description.isNotEmpty) ...[
                                    SizedBox(height: 4.h),
                                    Text(
                                      task.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: task.isCompleted
                                            ? const Color(
                                                0xFF9CA3AF,
                                              ).withValues(alpha: 0.6)
                                            : const Color(0xFF6B7280),
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05);
  }

  Widget _buildSwipeBackground({
    required Alignment alignment,
    required Color color,
    required IconData icon,
    required EdgeInsets padding,
  }) {
    return Container(
      alignment: alignment,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Icon(icon, color: Colors.white, size: 32.sp),
    );
  }

  Widget _buildCheckbox(BuildContext context) {
    return AnimatedContainer(
      duration: 300.ms,
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        color: task.isCompleted ? const Color(0xFF059669) : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: task.isCompleted
              ? const Color(0xFF10B981)
              : const Color(0xFFE5E7EB),
          width: 2,
        ),
        boxShadow: [
          if (task.isCompleted)
            BoxShadow(
              color: const Color(0xFF10B981).withValues(alpha: 0.3),
              blurRadius: 10,
              spreadRadius: 1,
            ),
        ],
      ),
      child: task.isCompleted
          ? Icon(
              Icons.check_rounded,
              size: 20.sp,
              color: Colors.white,
            ).animate().scale(curve: Curves.easeOutBack)
          : null,
    );
  }
}
