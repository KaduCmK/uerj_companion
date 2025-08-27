import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/features/auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state is Authenticated ? state.user : null;
          
          return Column(
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
          );
        },
      ),
    );
  }
}
