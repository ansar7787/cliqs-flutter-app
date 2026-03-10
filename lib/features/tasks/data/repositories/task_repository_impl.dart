import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TaskRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasks(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        final tasks = await remoteDataSource.getTasks(userId);
        return Right(tasks);
      } on AuthException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> addTask(String userId, TaskEntity task) async {
    if (await networkInfo.isConnected) {
      try {
        final taskModel = TaskModel(
          id: task.id,
          title: task.title,
          description: task.description,
          isCompleted: task.isCompleted,
          createdAt: task.createdAt,
        );
        await remoteDataSource.addTask(userId, taskModel);
        return const Right(null);
      } on AuthException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTask(
    String userId,
    TaskEntity task,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final taskModel = TaskModel(
          id: task.id,
          title: task.title,
          description: task.description,
          isCompleted: task.isCompleted,
          createdAt: task.createdAt,
        );
        await remoteDataSource.updateTask(userId, taskModel);
        return const Right(null);
      } on AuthException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String userId, String taskId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteTask(userId, taskId);
        return const Right(null);
      } on AuthException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
