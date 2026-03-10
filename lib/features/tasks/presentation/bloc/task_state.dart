import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';
import '../../../../core/error/failure.dart';

enum TaskStatus { initial, loading, loaded, error }

class TaskState extends Equatable {
  final TaskStatus status;
  final List<TaskEntity> tasks;
  final Failure? failure;

  const TaskState({
    this.status = TaskStatus.initial,
    this.tasks = const [],
    this.failure,
  });

  TaskState copyWith({
    TaskStatus? status,
    List<TaskEntity>? tasks,
    Failure? failure,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, tasks, failure];
}
