import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PremiumGlassTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  const PremiumGlassTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.focusNode,
    this.textInputAction,
  });

  @override
  State<PremiumGlassTextField> createState() => _PremiumGlassTextFieldState();
}

class _PremiumGlassTextFieldState extends State<PremiumGlassTextField>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _shakeController;
  late Animation<double> _glowAnimation;
  late Animation<double> _shakeAnimation;

  bool _obscureText = true;
  late FocusNode _focusNode;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.isPassword;

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _shakeController.reset();
        }
      });

    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _glowController.forward();
    } else {
      _glowController.reverse();
    }
    setState(() {});
  }

  void _shake() {
    _shakeController.forward(from: 0.0);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    _glowController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_glowAnimation, _shakeAnimation]),
      builder: (context, child) {
        final double sineValue = math.sin(_shakeAnimation.value * 3 * math.pi);
        final double offset = sineValue * 8.0;

        return Transform.translate(
          offset: Offset(offset, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    if (_glowAnimation.value > 0 || _errorText != null)
                      BoxShadow(
                        color: (_errorText != null
                                ? Colors.red
                                : const Color(0xFF10B981))
                            .withValues(
                          alpha: 0.15 *
                              (_errorText != null ? 1.0 : _glowAnimation.value),
                        ),
                        blurRadius: 15 *
                            (_errorText != null ? 1.0 : _glowAnimation.value),
                        spreadRadius: 2 *
                            (_errorText != null ? 1.0 : _glowAnimation.value),
                      ),
                  ],
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.all(_glowAnimation.value > 0 ? 2.0 : 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    gradient: _errorText != null
                        ? const LinearGradient(
                            colors: [Colors.red, Colors.redAccent],
                          )
                        : _glowAnimation.value > 0
                            ? const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF34D399)],
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.black.withValues(alpha: 0.05),
                                  Colors.black.withValues(alpha: 0.05),
                                ],
                              ),
                    boxShadow: [
                      if (_glowAnimation.value > 0)
                        BoxShadow(
                          color: const Color(
                            0xFF10B981,
                          ).withValues(alpha: 0.15),
                          blurRadius: 20 * _glowAnimation.value,
                          spreadRadius: 2,
                        ),
                      if (_errorText != null)
                        BoxShadow(
                          color: Colors.red.withValues(alpha: 0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(18.5.r),
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withValues(alpha: 0.8),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: TextFormField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      obscureText: _obscureText,
                      keyboardType: widget.keyboardType,
                      textInputAction: widget.textInputAction,
                      onChanged: (value) {
                        if (_errorText != null) {
                          setState(() => _errorText = null);
                        }
                      },
                      validator: (value) {
                        final result = widget.validator?.call(value);
                        if (result != null && _errorText == null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() => _errorText = result);
                            _shake();
                          });
                        }
                        return result;
                      },
                      style: GoogleFonts.outfit(
                        color: const Color(0xFF1F2937),
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: GoogleFonts.outfit(
                          color: const Color(0xFF9CA3AF),
                          fontSize: 15.sp,
                        ),
                        prefixIcon: Icon(
                          widget.prefixIcon,
                          color: _errorText != null
                              ? Colors.red
                              : Color.lerp(
                                  const Color(0xFF9CA3AF),
                                  const Color(0xFF059669),
                                  _glowAnimation.value,
                                ),
                          size: 22.sp,
                        ),
                        suffixIcon: widget.isPassword
                            ? IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFF9CA3AF),
                                  size: 20.sp,
                                ),
                                onPressed: () => setState(
                                  () => _obscureText = !_obscureText,
                                ),
                              )
                            : null,
                        border: InputBorder.none,
                        errorStyle: const TextStyle(height: 0, fontSize: 0),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 18.h,
                          horizontal: 20.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_errorText != null)
                Padding(
                  padding: EdgeInsets.only(left: 12.w, top: 6.h),
                  child: Text(
                    _errorText!,
                    style: GoogleFonts.outfit(
                      color: Colors.red,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
