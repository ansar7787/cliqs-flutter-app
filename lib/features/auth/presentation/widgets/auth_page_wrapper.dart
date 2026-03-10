import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/presentation/widgets/loading_overlay.dart';
import '../../../../core/presentation/widgets/glass_tile.dart';

class AuthPageWrapper extends StatelessWidget {
  final Widget header;
  final Widget form;
  final Widget? footer;
  final bool isLoading;
  final GlobalKey<FormState>? formKey;
  final VoidCallback? onBack;

  const AuthPageWrapper({
    super.key,
    required this.header,
    required this.form,
    this.footer,
    this.isLoading = false,
    this.formKey,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              header,
                              GlassTile(
                                padding: EdgeInsets.all(24.r),
                                borderRadius: BorderRadius.circular(32.r),
                                opacity: 0.2,
                                child: form,
                              ),
                              if (footer != null) ...[
                                SizedBox(height: 32.h),
                                footer!,
                              ],
                              SizedBox(height: 24.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (onBack != null)
              Positioned(
                top: 10.h,
                left: 10.w,
                child: SafeArea(
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF1F2937),
                    ),
                    onPressed: onBack,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
