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
  }) : super(TaskInitial()) {
    on<LoadTasksEvent>((event, emit) async {
      emit(TaskLoading());
      final result = await getTasks(event.userId);
      result.fold(
        (failure) => emit(TaskError(failure.message)),
        (tasks) => emit(
          TasksLoaded(
            tasks..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
          ),
        ),
      );
    });

    on<AddTaskEvent>((event, emit) async {
      final task = TaskEntity(
        id: '', // Backend generates ID or we'll let REST handle it
        title: event.title,
        description: event.description,
        createdAt: DateTime.now(),
      );
      final result = await addTask(
        AddTaskParams(userId: event.userId, task: task),
      );
      result.fold(
        (failure) => emit(TaskError(failure.message)),
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
        (failure) => emit(TaskError(failure.message)),
        (_) => add(LoadTasksEvent(event.userId)),
      );
    });

    on<DeleteTaskEvent>((event, emit) async {
      final result = await deleteTask(
        DeleteTaskParams(userId: event.userId, taskId: event.taskId),
      );
      result.fold(
        (failure) => emit(TaskError(failure.message)),
        (_) => add(LoadTasksEvent(event.userId)),
      );
    });
  }
}
