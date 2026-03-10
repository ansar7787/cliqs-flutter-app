import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/glass_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_redirect_row.dart';
import '../widgets/auth_page_wrapper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) context.go('/');
        if (state.status == AuthStatus.error) {
          _showSnackBar(context, state.errorMessage ?? 'Error', Colors.red);
        }
      },
      builder: (context, state) {
        final isLoading = state.status == AuthStatus.loading;
        return AuthPageWrapper(
          isLoading: isLoading,
          formKey: _formKey,
          header: const AuthHeader(
            title: 'CLIQS',
            subtitle: 'Elevate Your Daily Connection',
          ),
          form: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildEmailField(),
              SizedBox(height: 16.h),
              _buildPasswordField(),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push('/forgot-password'),
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF059669),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              AuthButton(
                label: 'Login',
                isLoading: isLoading,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthBloc>().add(
                      LoginSubmitted(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          footer: AuthRedirectRow(
            text: "Don't have an account? ",
            linkText: 'Sign Up',
            onTap: () => context.push('/signup'),
          ),
        );
      },
    );
  }

  Widget _buildEmailField() {
    return PremiumGlassTextField(
      controller: _emailController,
      focusNode: _emailFocus,
      hintText: 'Email address',
      prefixIcon: Icons.alternate_email_rounded,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
    );
  }

  Widget _buildPasswordField() {
    return PremiumGlassTextField(
      controller: _passwordController,
      focusNode: _passwordFocus,
      hintText: 'Password',
      prefixIcon: Icons.lock_person_rounded,
      isPassword: true,
      textInputAction: TextInputAction.done,
      validator: (value) => value!.length < 6 ? 'Password too short' : null,
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w500),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
