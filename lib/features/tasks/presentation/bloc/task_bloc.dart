import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_tasks.dart';
import '../../domain/usecases/update_task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskBloc({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(const TaskState()) {
    on<LoadTasksEvent>((event, emit) async {
      emit(state.copyWith(status: TaskStatus.loading));
      final result = await getTasks(GetTasksParams(userId: event.userId));
      result.fold(
        (failure) =>
            emit(state.copyWith(status: TaskStatus.error, failure: failure)),
        (tasks) {
          final sortedTasks = List<TaskEntity>.from(tasks)
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          emit(state.copyWith(status: TaskStatus.loaded, tasks: sortedTasks));
        },
      );
    });

    on<AddTaskEvent>((event, emit) async {
      final task = TaskEntity(
        id: '', // Backend generates ID
        title: event.title,
        description: event.description,
        createdAt: DateTime.now(),
      );
      final result = await addTask(
        AddTaskParams(userId: event.userId, task: task),
      );
      result.fold(
        (failure) =>
            emit(state.copyWith(status: TaskStatus.error, failure: failure)),
        (_) => add(LoadTasksEvent(event.userId)),
      );
    });

    on<ToggleTaskCompletionEvent>((event, emit) async {
      final updatedTask = event.task.copyWith(
        isCompleted: !event.task.isCompleted,
      );
      final result = await updateTask(
        UpdateTaskParams(userId: event.userId, task: updatedTask),
      );
      result.fold(
        (failure) =>
            emit(state.copyWith(status: TaskStatus.error, failure: failure)),
        (_) => add(LoadTasksEvent(event.userId)),
      );
    });

    on<DeleteTaskEvent>((event, emit) async {
      final result = await deleteTask(
        DeleteTaskParams(userId: event.userId, taskId: event.taskId),
      );
      result.fold(
        (failure) =>
            emit(state.copyWith(status: TaskStatus.error, failure: failure)),
        (_) => add(LoadTasksEvent(event.userId)),
      );
    });

    on<UpdateTaskEvent>((event, emit) async {
      final result = await updateTask(
        UpdateTaskParams(userId: event.userId, task: event.task),
      );
      result.fold(
        (failure) =>
            emit(state.copyWith(status: TaskStatus.error, failure: failure)),
        (_) => add(LoadTasksEvent(event.userId)),
      );
    });
  }
}
