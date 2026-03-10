import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class AddTask implements UseCase<void, AddTaskParams> {
  final TaskRepository repository;

  AddTask(this.repository);

  @override
  Future<Either<Failure, void>> call(AddTaskParams params) {
    return repository.addTask(params.userId, params.task);
  }
}

class AddTaskParams extends Equatable {
  final String userId;
  final TaskEntity task;

  const AddTaskParams({required this.userId, required this.task});

  @override
  List<Object?> get props => [userId, task];
}
