import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Bem-vindo, ${user?.email ?? 'Visitante'}!',
            style: textTheme.headlineSmall,
          ),
          const Divider(),
          Text("Acesso Rápido:", style: textTheme.titleMedium),
          OutlinedButton(
            child: const Text("Cursos & Matérias"),
            onPressed: () => context.go('/info-cursos'),
          ),
          OutlinedButton(
            child: const Text("Docentes"),
            onPressed: () => context.go('/docentes'),
          ),
        ],
      ),
    );
  }
}
