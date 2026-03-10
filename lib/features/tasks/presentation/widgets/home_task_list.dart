import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import 'task_tile.dart';
import 'task_shimmer.dart';
import 'task_empty_state.dart';
import 'task_sheet_helper.dart';

class HomeTaskList extends StatelessWidget {
  final String userId;

  const HomeTaskList({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      sliver: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state.status == TaskStatus.loading) {
            return const SliverToBoxAdapter(child: TaskShimmer());
          }
          if (state.status == TaskStatus.loaded) {
            if (state.tasks.isEmpty) {
              return const TaskEmptyState(
                icon: Icons.wb_sunny_outlined,
                title: 'Quiet day ahead',
                subtitle: 'Tap below to add your first goal.',
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final task = state.tasks[index];
                return TaskTile(
                  task: task,
                  onToggle: () => context.read<TaskBloc>().add(
                    ToggleTaskCompletionEvent(userId: userId, task: task),
                  ),
                  onDelete: () => context.read<TaskBloc>().add(
                    DeleteTaskEvent(userId: userId, taskId: task.id),
                  ),
                  onEdit: () => TaskSheetHelper.show(context, task: task),
                );
              }, childCount: state.tasks.length),
            );
          }
          return const SliverToBoxAdapter(child: SizedBox());
        },
      ),
    );
  }
}
