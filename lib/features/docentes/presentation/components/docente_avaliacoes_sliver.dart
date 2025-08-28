import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uerj_companion/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:uerj_companion/features/docentes/presentation/bloc/avaliacoes/avaliacoes_bloc.dart';
import 'package:uerj_companion/features/docentes/presentation/components/avaliacao_card.dart';
import 'package:uerj_companion/features/docentes/presentation/components/docente_rating.dart';

class DocenteAvaliacoesSliver extends StatelessWidget {
  final AvaliacoesDataState state;
  const DocenteAvaliacoesSliver({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // userId precisa existir ou ser vazio.
    //se o usuario nao estiver logado (userId == null) e review nao possuir userId, ele achará que existe um review do usuario
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final minhaAvaliacao = state.avaliacoes.firstWhereOrNull(
      (av) => av.userId == userId,
    );
    final outrasAvaliacoes = state.avaliacoes
        .where((av) => av.userId != userId)
        .toList();

    print(minhaAvaliacao);

    return SliverMainAxisGroup(
      slivers: [
        // Header avaliacoes
        SliverPadding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 8),
          sliver: SliverToBoxAdapter(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                final isAuthenticated = authState is Authenticated;

                return Column(
                  spacing: 8,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          minhaAvaliacao != null
                              ? "Sua Avaliação"
                              : "Avaliações",
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isAuthenticated)
                          if (minhaAvaliacao == null)
                            OutlinedButton.icon(
                              onPressed: () => context
                                  .read<AvaliacoesBloc>()
                                  .add(EditAvaliacao()),
                              icon: Icon(Icons.rate_review),
                              label: const Text("Avaliar Professor"),
                            )
                          else
                            IconButton(
                              onPressed: () =>
                                  context.read<AvaliacoesBloc>().add(
                                    EditAvaliacao(avaliacao: minhaAvaliacao),
                                  ),
                              icon: Icon(Icons.edit),
                            ),
                      ],
                    ),

                    if (!isAuthenticated)
                      Chip(
                        label: Text(
                          "Quer avaliar este professor? Faça login!",
                          style: textTheme.bodyMedium,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),

        // Caso usuario ja tenha uma avaliacao, ela aparece separada
        if (minhaAvaliacao != null)
          SliverToBoxAdapter(child: AvaliacaoCard(avaliacao: minhaAvaliacao)),

        // Outras avaliacoes do professor
        if (outrasAvaliacoes.isNotEmpty) ...[
          SliverPadding(
            padding: const EdgeInsets.only(top: 8),
            sliver: SliverToBoxAdapter(
              child: Text("Outras Avaliações", style: textTheme.titleMedium),
            ),
          ),
          SliverList.builder(
            itemCount: outrasAvaliacoes.length,
            itemBuilder: (context, index) =>
                AvaliacaoCard(avaliacao: outrasAvaliacoes[index]),
          ),
        ],
      ],
    );
  }
}
