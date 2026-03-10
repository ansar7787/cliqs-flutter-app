import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUser implements UseCase<UserEntity, SignupParams> {
  final AuthRepository repository;

  SignupUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignupParams params) {
    return repository.signup(params.email, params.password, params.name);
  }
}

class SignupParams extends Equatable {
  final String email;
  final String password;
  final String name;

  const SignupParams({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}
