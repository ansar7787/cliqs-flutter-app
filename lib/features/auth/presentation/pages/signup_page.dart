import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/presentation/widgets/glass_text_field.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_redirect_row.dart';
import '../widgets/auth_page_wrapper.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _nameFocus.dispose();
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
          onBack: () => context.pop(),
          header: const AuthHeader(
            title: 'CLIQS',
            subtitle: 'Create your premium account',
          ),
          form: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildNameField(),
              SizedBox(height: 16.h),
              _buildEmailField(),
              SizedBox(height: 16.h),
              _buildPasswordField(),
              SizedBox(height: 32.h),
              AuthButton(
                label: 'Create Account',
                isLoading: isLoading,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthBloc>().add(
                      SignupSubmitted(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                        _nameController.text.trim(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          footer: AuthRedirectRow(
            text: "Already have an account? ",
            linkText: 'Login',
            onTap: () => context.pop(),
          ),
        );
      },
    );
  }

  Widget _buildNameField() {
    return PremiumGlassTextField(
      controller: _nameController,
      focusNode: _nameFocus,
      hintText: 'Full Name',
      prefixIcon: Icons.person_outline_rounded,
      textInputAction: TextInputAction.next,
      validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
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
      hintText: 'Create Password',
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
        content: Text(message, style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
