import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uerj_companion/features/docentes/presentation/bloc/avaliacoes/avaliacoes_bloc.dart';
import 'package:uerj_companion/features/docentes/presentation/components/docente_rating.dart';

class DocenteAvaliacoesSliver extends StatelessWidget {
  final AvaliacoesDataState state;
  const DocenteAvaliacoesSliver({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    final minhaAvaliacao = state.avaliacoes.firstWhereOrNull(
      (av) => av.userId == userId,
    );
    final outrasAvaliacoes = state.avaliacoes
        .where((av) => av.userId != userId)
        .toList();

    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 8),
          sliver: SliverToBoxAdapter(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  minhaAvaliacao != null ? "Sua Avaliação" : "Avaliações",
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (minhaAvaliacao == null)
                  OutlinedButton.icon(
                    onPressed: () =>
                        context.read<AvaliacoesBloc>().add(EditAvaliacao()),
                    icon: Icon(Icons.rate_review),
                    label: const Text("Avaliar Professor"),
                  )
                else
                  IconButton(
                    onPressed: () => context.read<AvaliacoesBloc>().add(
                      EditAvaliacao(avaliacao: minhaAvaliacao),
                    ),
                    icon: Icon(Icons.edit),
                  ),
              ],
            ),
          ),
        ),

        if (minhaAvaliacao != null)
          SliverToBoxAdapter(
            child: Card(
              child: ListTile(
                title: DocenteRating(rating: minhaAvaliacao.nota.toDouble()),
                subtitle: minhaAvaliacao.comentario != null
                    ? Text(
                        minhaAvaliacao.comentario!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
              ),
            ),
          ),

        if (outrasAvaliacoes.isNotEmpty) ...[
          SliverPadding(
            padding: const EdgeInsets.only(top: 8),
            sliver: SliverToBoxAdapter(
              child: Text("Outras Avaliações", style: textTheme.titleMedium),
            ),
          ),
          SliverList.builder(
            itemCount: outrasAvaliacoes.length,
            itemBuilder: (context, index) => ListTile(
              title: DocenteRating(
                rating: outrasAvaliacoes[index].nota.toDouble(),
              ),
              subtitle: outrasAvaliacoes[index].comentario != null
                  ? Text(
                      outrasAvaliacoes[index].comentario!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null
            ),
          ),
        ],
      ],
    );
  }
}
