import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uerj_companion/features/docentes/presentation/bloc/docentes/docentes_bloc.dart';
import 'package:uerj_companion/features/docentes/presentation/components/docente_rating.dart';
import 'package:uerj_companion/shared/components/typewriter_fade_text.dart';

class DocenteProfileCard extends StatelessWidget {
  final DocenteProfileLoaded state;

  const DocenteProfileCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          spacing: 4,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: BackButton(
                onPressed: () =>
                    context.read<DocentesBloc>().add(GetDocentes()),
              ),
            ),
            Text(
              state.docente.nome,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            DocenteRating(rating: state.docente.mediaAvaliacoes),
            Row(
              spacing: 4,
              children: [
                Icon(Icons.email, size: 16),
                Text(state.docente.email ?? 'Nenhum email cadastrado'),
              ],
            ),
            const Padding(padding: EdgeInsetsGeometry.all(8), child: Divider()),
            Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 4,
                      children: [
                        SvgPicture.asset(
                          'sparkle.svg',
                          semanticsLabel: 'Resumo IA',
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.onSurface,
                            BlendMode.srcIn,
                          ),
                          width: 24,
                          height: 24,
                        ),
                        Text(
                          'Resumo gerado por IA:',
                          style: textTheme.titleMedium,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TypewriterFadeText(
                        text: state.docente.resumoIA ?? 'Nenhum resumo gerado',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
