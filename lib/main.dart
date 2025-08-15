import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uerj_companion/app_theme.dart';
import 'package:uerj_companion/firebase_options.dart';
import 'package:uerj_companion/shared/config/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Uerjiano',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
