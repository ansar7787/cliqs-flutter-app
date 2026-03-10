import 'package:equatable/equatable.dart';
import '../../domain/entities/task_entity.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TaskEvent {
  final String userId;
  const LoadTasksEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddTaskEvent extends TaskEvent {
  final String userId;
  final String title;
  final String description;

  const AddTaskEvent({
    required this.userId,
    required this.title,
    this.description = '',
  });

  @override
  List<Object?> get props => [userId, title, description];
}

class ToggleTaskCompletionEvent extends TaskEvent {
  final String userId;
  final TaskEntity task;

  const ToggleTaskCompletionEvent({required this.userId, required this.task});

  @override
  List<Object?> get props => [userId, task];
}

class DeleteTaskEvent extends TaskEvent {
  final String userId;
  final String taskId;

  const DeleteTaskEvent({required this.userId, required this.taskId});

  @override
  List<Object?> get props => [userId, taskId];
}
