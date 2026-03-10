import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import 'add_task_sheet.dart';

class TaskSheetHelper {
  static void show(BuildContext context, {TaskEntity? task}) {
    final authState = context.read<AuthBloc>().state;
    if (authState.status == AuthStatus.authenticated &&
        authState.user != null) {
      final user = authState.user!;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) => AddTaskSheet(
          initialTitle: task?.title,
          initialDescription: task?.description,
          onSave: (title, desc) {
            final taskBloc = context.read<TaskBloc>();
            if (task == null) {
              taskBloc.add(
                AddTaskEvent(userId: user.id, title: title, description: desc),
              );
            } else {
              taskBloc.add(
                UpdateTaskEvent(
                  userId: user.id,
                  task: task.copyWith(title: title, description: desc),
                ),
              );
            }
          },
        ),
      );
    }
  }
}
