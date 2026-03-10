import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/tasks/presentation/bloc/task_bloc.dart';
import 'core/router/app_router.dart';
import 'core/network/connectivity_bloc.dart';
import 'core/presentation/pages/network_error_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
            ),
            BlocProvider(create: (_) => di.sl<TaskBloc>()),
            BlocProvider(create: (_) => di.sl<ConnectivityBloc>()),
          ],
          child: MaterialApp.router(
            title: 'Cliqs Todo',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.router,
            builder: (context, child) {
              return BlocBuilder<ConnectivityBloc, ConnectivityState>(
                builder: (context, state) {
                  if (!state.isConnected) {
                    return NetworkErrorPage(
                      onRetry: () {
                        context.read<ConnectivityBloc>().add(
                          ConnectivityChanged(const []),
                        );
                      },
                    );
                  }
                  return child!;
                },
              );
            },
          ),
        );
      },
    );
  }
}
