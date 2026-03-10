import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../auth/presentation/bloc/auth_event.dart';
import '../../auth/presentation/bloc/auth_state.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/task_tile.dart';
import '../widgets/task_shimmer.dart';
import '../widgets/add_task_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<TaskBloc>().add(LoadTasksEvent(authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is! Authenticated) return const SizedBox();
            final user = authState.user;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello ${user.name ?? 'User'} 👋',
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(color: Colors.grey),
                                ),
                                Text(
                                  "Today's Tasks",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () => context.read<AuthBloc>().add(
                                LogoutRequested(),
                              ),
                              icon: const Icon(Icons.logout_rounded),
                              color: Colors.red.shade400,
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        _buildProgressCard(context),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  sliver: SliverToBoxAdapter(
                    child: BlocBuilder<TaskBloc, TaskState>(
                      builder: (context, state) {
                        if (state is TaskLoading) return const TaskShimmer();
                        if (state is TasksLoaded) {
                          if (state.tasks.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 40.h),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.task_alt,
                                      size: 80.w,
                                      color: Colors.grey.shade300,
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'No tasks yet! 🎉',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                    Text(
                                      'Tap + to add your first task',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animate().fadeIn();
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.tasks.length,
                            itemBuilder: (context, index) {
                              final task = state.tasks[index];
                              return TaskTile(
                                task: task,
                                onToggle: () => context.read<TaskBloc>().add(
                                  ToggleTaskCompletionEvent(
                                    userId: user.id,
                                    task: task,
                                  ),
                                ),
                                onDelete: () => context.read<TaskBloc>().add(
                                  DeleteTaskEvent(
                                    userId: user.id,
                                    taskId: task.id,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final authState = context.read<AuthBloc>().state;
          if (authState is Authenticated) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              builder: (context) => AddTaskSheet(
                onSave: (title, desc) => context.read<TaskBloc>().add(
                  AddTaskEvent(
                    userId: authState.user.id,
                    title: title,
                    description: desc,
                  ),
                ),
              ),
            );
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ).animate().scale(delay: 500.ms),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        int completed = 0;
        int total = 0;
        if (state is TasksLoaded) {
          total = state.tasks.length;
          completed = state.tasks.where((t) => t.isCompleted).length;
        }

        double progress = total == 0 ? 0 : completed / total;

        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Progress',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$completed/$total Tasks',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8.h,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                progress == 1.0
                    ? 'You completed all tasks! 🎊'
                    : '${(progress * 100).toInt()}% completed',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: 0.2);
      },
    );
  }
}
