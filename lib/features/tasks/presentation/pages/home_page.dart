import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';
import '../widgets/aura_background.dart';
import '../widgets/task_action_fab.dart';
import '../widgets/task_sheet_helper.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/home_progress_section.dart';
import '../widgets/home_section_header.dart';
import '../widgets/home_task_list.dart';
import '../../../../core/error/failure.dart';
import 'all_tasks_page.dart';

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
    if (authState.status == AuthStatus.authenticated &&
        authState.user != null) {
      context.read<TaskBloc>().add(LoadTasksEvent(authState.user!.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state.status == TaskStatus.error &&
            state.failure is! NetworkFailure) {
          _showSnackBar(context, state.failure!.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState.status != AuthStatus.authenticated ||
                  authState.user == null) {
                return const SizedBox();
              }
              final user = authState.user!;

              return Stack(
                children: [
                  const AuraBackground(),
                  RefreshIndicator(
                    onRefresh: () async {
                      context.read<TaskBloc>().add(LoadTasksEvent(user.id));
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    color: const Color(0xFF059669),
                    backgroundColor: Colors.white,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              24.w,
                              32.h,
                              24.w,
                              16.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HomeTopBar(
                                  name: user.name ?? 'Friend',
                                  onProfileTap: () =>
                                      _showLogoutDialog(context),
                                ),
                                SizedBox(height: 48.h),
                                const HomeProgressSection(),
                                SizedBox(height: 40.h),
                                HomeSectionHeader(
                                  title: "Today's Goals",
                                  onViewAllTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AllTasksPage(),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                              ],
                            ),
                          ),
                        ),
                        HomeTaskList(userId: user.id),
                        SliverToBoxAdapter(child: SizedBox(height: 120.h)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: TaskActionFab(
          onTap: () => TaskSheetHelper.show(context),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        title: Text(
          'Account',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Would you like to log out?',
          style: GoogleFonts.outfit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.outfit(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutRequested());
            },
            child: Text(
              'Logout',
              style: GoogleFonts.outfit(
                color: Colors.red.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
