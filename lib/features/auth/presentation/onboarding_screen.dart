import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uerj_companion/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uerj_companion/features/cursos/domain/entities/curso.dart';
import 'package:uerj_companion/features/cursos/presentation/bloc/curso_bloc.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Curso? selectedCurso;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    // if (authState is Unauthenticated)
      // context.read<AuthBloc>().add(SignInAnonymously());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated)
            context.read<CursoBloc>().add(LoadCursos());
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Bem-vindo!'),

                BlocBuilder<CursoBloc, CursoState>(
                  builder: (context, state) {
                    if (state is! CursosLoaded)
                      return const Center(child: CircularProgressIndicator());

                    final items = state.cursos
                        .map(
                          (curso) => DropdownMenuItem(
                            value: curso,
                            child: Text(curso.name),
                          ),
                        )
                        .toList();

                    return DropdownButtonFormField<Curso>(
                      initialValue: selectedCurso,
                      items: items,
                      onChanged: (value) => setState(() {
                        selectedCurso = value;
                      }),
                    );
                  },
                ),

                const SizedBox(height: 16),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    ElevatedButton(
                      onPressed: null,
                      child: const Text('Entrar'),
                      //  () => 
                      // context.read<AuthBloc>().add(
                      //   // CompleteOnboarding(curso: selectedCurso!),
                      // ),
                    ),
                    TextButton(
                      onPressed: null,
                      //  () =>
                      //     context.read<AuthBloc>().add(CompleteOnboarding()),
                      child: const Text('Entrar sem curso'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
