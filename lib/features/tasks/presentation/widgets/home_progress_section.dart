import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_state.dart';
import 'welcome_glass_slab.dart';

class HomeProgressSection extends StatelessWidget {
  const HomeProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TaskBloc, TaskState, (int, int)>(
      selector: (state) {
        if (state.status == TaskStatus.loaded) {
          final total = state.tasks.length;
          final completed = state.tasks.where((t) => t.isCompleted).length;
          return (total, completed);
        }
        return (0, 0);
      },
      builder: (context, counts) {
        return WelcomeGlassSlab(
          totalTasks: counts.$1,
          completedTasks: counts.$2,
        );
      },
    );
  }
}
