abstract class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class UserNotFoundException extends AuthException {
  UserNotFoundException() : super('User not found');
}

class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException() : super('Invalid email or password');
}

class EmailAlreadyInUseException extends AuthException {
  EmailAlreadyInUseException() : super('Email already in use');
}

class WeakPasswordException extends AuthException {
  WeakPasswordException() : super('Password is too weak');
}

class NetworkException extends AuthException {
  NetworkException() : super('No internet connection');
}

class ServerException extends AuthException {
  ServerException([super.message = 'A server error occurred']);
}
