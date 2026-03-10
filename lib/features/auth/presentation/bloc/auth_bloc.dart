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
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>((event, emit) async {
      final result = await getCurrentUser(NoParams());
      result.fold((failure) => emit(Unauthenticated()), (user) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      });
    });

    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUser(
        LoginParams(email: event.email, password: event.password),
      );
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(Authenticated(user)),
      );
    });

    on<SignupSubmitted>((event, emit) async {
      emit(AuthLoading());
      final result = await signupUser(
        SignupParams(
          email: event.email,
          password: event.password,
          name: event.name,
        ),
      );
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(Authenticated(user)),
      );
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await logoutUser(NoParams());
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (_) => emit(Unauthenticated()),
      );
    });

    on<PasswordResetRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await sendPasswordResetEmail(event.email);
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (_) => emit(PasswordResetEmailSent()),
      );
    });
  }
}
