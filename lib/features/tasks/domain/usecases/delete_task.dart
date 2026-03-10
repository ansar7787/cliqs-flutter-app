import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/task_repository.dart';

class DeleteTask implements UseCase<void, DeleteTaskParams> {
  final TaskRepository repository;

  DeleteTask(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteTaskParams params) {
    return repository.deleteTask(params.userId, params.taskId);
  }
}

class DeleteTaskParams extends Equatable {
  final String userId;
  final String taskId;

  const DeleteTaskParams({required this.userId, required this.taskId});

  @override
  List<Object?> get props => [userId, taskId];
}
