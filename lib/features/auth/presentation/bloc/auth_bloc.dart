import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/send_password_reset_email.dart';
import '../../domain/usecases/signup_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final SignupUser signupUser;
  final LogoutUser logoutUser;
  final GetCurrentUser getCurrentUser;
  final SendPasswordResetEmail sendPasswordResetEmail;

  AuthBloc({
    required this.loginUser,
    required this.signupUser,
    required this.logoutUser,
    required this.getCurrentUser,
    required this.sendPasswordResetEmail,
  }) : super(const AuthState()) {
    on<AuthCheckRequested>((event, emit) async {
      final result = await getCurrentUser(NoParams());
      result.fold(
        (failure) => emit(state.copyWith(status: AuthStatus.unauthenticated)),
        (user) {
          if (user != null) {
            emit(state.copyWith(status: AuthStatus.authenticated, user: user));
          } else {
            emit(state.copyWith(status: AuthStatus.unauthenticated));
          }
        },
      );
    });

    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(status: AuthStatus.loading));
      final result = await loginUser(
        LoginParams(email: event.email, password: event.password),
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (user) =>
            emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
      );
    });

    on<SignupSubmitted>((event, emit) async {
      emit(state.copyWith(status: AuthStatus.loading));
      final result = await signupUser(
        SignupParams(
          email: event.email,
          password: event.password,
          name: event.name,
        ),
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (user) =>
            emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
      );
    });

    on<LogoutRequested>((event, emit) async {
      emit(state.copyWith(status: AuthStatus.loading));
      final result = await logoutUser(NoParams());
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (_) => emit(const AuthState(status: AuthStatus.unauthenticated)),
      );
    });

    on<PasswordResetRequested>((event, emit) async {
      emit(state.copyWith(status: AuthStatus.loading));
      final result = await sendPasswordResetEmail(
        ResetPasswordParams(email: event.email),
      );
      result.fold(
        (failure) => emit(
          state.copyWith(
            status: AuthStatus.error,
            errorMessage: failure.message,
          ),
        ),
        (_) => emit(state.copyWith(status: AuthStatus.passwordResetSent)),
      );
    });
  }
}
