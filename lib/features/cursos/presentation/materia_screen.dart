import 'package:flutter/material.dart';
import 'package:uerj_companion/features/cursos/domain/entities/materia.dart';

class MateriaScreen extends StatelessWidget {
  final Materia materia;

  const MateriaScreen({super.key, required this.materia});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24),
      child: Center(
        child: Column(
          spacing: 8,
          children: [
            Text(
              materia.name ?? 'Matéria sem nome',
              style: textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
