import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class AddTaskSheet extends StatefulWidget {
  final Function(String title, String desc) onSave;
  final String? initialTitle;
  final String? initialDescription;

  const AddTaskSheet({
    super.key,
    required this.onSave,
    this.initialTitle,
    this.initialDescription,
  });

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _titleFocus = FocusNode();
  final _descFocus = FocusNode();
  bool _showTitleError = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initialTitle ?? '';
    _descController.text = widget.initialDescription ?? '';
    _titleFocus.addListener(() => setState(() {}));
    _descFocus.addListener(() => setState(() {}));

    _titleController.addListener(() {
      if (_showTitleError && _titleController.text.isNotEmpty) {
        setState(() => _showTitleError = false);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _titleFocus.dispose();
    _descFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
        left: 24.w,
        right: 24.w,
        top: 32.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.initialTitle == null ? 'Add a task' : 'Refine task',
                  style: GoogleFonts.outfit(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            _buildField(
              controller: _titleController,
              focusNode: _titleFocus,
              hint: 'What needs to be done?',
              autofocus: true,
              maxLength: 50,
              textInputAction: TextInputAction.next,
              errorText: _showTitleError ? 'Please enter a title' : null,
            ),
            SizedBox(height: 16.h),
            _buildField(
              controller: _descController,
              focusNode: _descFocus,
              hint: 'Add some notes (optional)',
              maxLines: 3,
              maxLength: 200,
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.trim().isEmpty) {
                  setState(() => _showTitleError = true);
                  _titleFocus.requestFocus();
                  return;
                }
                widget.onSave(
                  _titleController.text.trim(),
                  _descController.text.trim(),
                );
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 56.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                elevation: 4,
                shadowColor: const Color(0xFF059669).withValues(alpha: 0.3),
              ),
              child: Text(
                'Save task',
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    bool autofocus = false,
    int maxLines = 1,
    int? maxLength,
    TextInputAction? textInputAction,
    String? errorText,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      maxLines: maxLines,
      maxLength: maxLength,
      textInputAction: textInputAction,
      style: GoogleFonts.outfit(
        color: const Color(0xFF1F2937),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(
          color: const Color(0xFF9CA3AF),
          fontWeight: FontWeight.w400,
        ),
        errorText: errorText,
        errorStyle: GoogleFonts.outfit(
          color: Colors.red.shade400,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        counterStyle: GoogleFonts.outfit(
          color: const Color(0xFF9CA3AF),
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Color(0xFF059669), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
      ),
    );
  }
}
