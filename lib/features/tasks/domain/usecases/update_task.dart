import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class UpdateTask implements UseCase<void, UpdateTaskParams> {
  final TaskRepository repository;

  UpdateTask(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateTaskParams params) {
    return repository.updateTask(params.userId, params.task);
  }
}

class UpdateTaskParams extends Equatable {
  final String userId;
  final TaskEntity task;

  const UpdateTaskParams({required this.userId, required this.task});

  @override
  List<Object?> get props => [userId, task];
}
