import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/app_theme.dart';
import 'package:uerj_companion/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uerj_companion/firebase_options.dart';
import 'package:uerj_companion/shared/router/app_router.dart';
import 'package:uerj_companion/shared/config/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupLocator();

  final appRouter = createAppRouter(sl<AuthBloc>());

  runApp(
    BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: MyApp(router: appRouter),
    ),
  );
}

class MyApp extends StatefulWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(
      CheckSignInLink(Uri.parse(Uri.base.toString())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Uerjiano',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: widget.router,
      builder: (context, child) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            // Este listener vai pegar erros de qualquer lugar,
            // incluindo a falha de login pelo link.
            if (state is AuthError) {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
          child: child!,
        );
      },
    );
  }
}
