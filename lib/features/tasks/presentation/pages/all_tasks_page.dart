import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/task_tile.dart';
import '../widgets/aura_background.dart';
import '../widgets/task_empty_state.dart';
import '../widgets/task_action_fab.dart';
import '../widgets/task_sheet_helper.dart';
import '../../domain/entities/task_entity.dart';

class AllTasksPage extends StatelessWidget {
  const AllTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final userId =
        (authState.status == AuthStatus.authenticated && authState.user != null)
        ? authState.user!.id
        : '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const AuraBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: BlocBuilder<TaskBloc, TaskState>(
                    builder: (context, state) {
                      if (state.status == TaskStatus.loaded) {
                        if (state.tasks.isEmpty) {
                          return const TaskEmptyState(
                            icon: Icons.task_alt_rounded,
                            title: 'No tasks found',
                            subtitle: 'Your workspace is clear.',
                            isSliver: false,
                          );
                        }
                        return _buildListView(context, state.tasks, userId);
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: TaskActionFab(
        onTap: () => TaskSheetHelper.show(context),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            'All Tasks',
            style: GoogleFonts.outfit(
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF111827),
              letterSpacing: -1.0,
            ),
          ),
          const Spacer(),
          _buildSearchIcon(),
        ],
      ),
    );
  }

  Widget _buildSearchIcon() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white),
      ),
      child: const Icon(
        Icons.search_rounded,
        color: Color(0xFF6B7280),
        size: 22,
      ),
    );
  }

  Widget _buildListView(
    BuildContext context,
    List<TaskEntity> tasks,
    String userId,
  ) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 100.h),
      physics: const BouncingScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
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
      },
    );
  }
}
