import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getTasks(String userId);
  Future<Either<Failure, void>> addTask(String userId, TaskEntity task);
  Future<Either<Failure, void>> updateTask(String userId, TaskEntity task);
  Future<Either<Failure, void>> deleteTask(String userId, String taskId);
}
