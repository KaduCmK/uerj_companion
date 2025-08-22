import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uerj_companion/features/docentes/presentation/bloc/avaliacoes/avaliacoes_bloc.dart';
import 'package:uerj_companion/features/docentes/presentation/bloc/docentes/docentes_bloc.dart';
import 'package:uerj_companion/features/docentes/presentation/rating_dialog.dart';

class DocenteProfileScreen extends StatefulWidget {
  final String docenteId;

  const DocenteProfileScreen({super.key, required this.docenteId});

  @override
  State<DocenteProfileScreen> createState() => _DocenteProfileScreenState();
}

class _DocenteProfileScreenState extends State<DocenteProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DocentesBloc>().add(
      SelectDocente(docenteId: widget.docenteId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            BlocBuilder<DocentesBloc, DocentesState>(
              builder: (context, state) {
                if (state is! DocenteProfileLoaded)
                  return const SliverToBoxAdapter();

                return SliverToBoxAdapter(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Column(
                        spacing: 4,
                        children: [
                          Text(
                            state.docente.nome,
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              5,
                              (_) => Icon(Icons.star_outline),
                            ),
                          ),
                          Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.email, size: 16),
                              Text(state.docente.email),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsetsGeometry.all(8),
                            child: Divider(),
                          ),
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
                          TextField(
                            minLines: 5,
                            maxLines: null,
                            readOnly: true,
                            controller: TextEditingController(
                              text:
                                  'Ainda não temos avaliações o suficiente para gerar um resumo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            BlocBuilder<AvaliacoesBloc, AvaliacoesState>(
              builder: (context, state) {
                if (state is! AvaliacoesLoaded)
                  return const SliverToBoxAdapter(
                    child: CircularProgressIndicator(),
                  );

                if (state.avaliacoes.isEmpty)
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        "Este professor ainda não foi avaliado. Seja o primeiro a avaliar!",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );

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
                              minhaAvaliacao != null
                                  ? "Sua Avaliação"
                                  : "Avaliações",
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (minhaAvaliacao == null)
                              OutlinedButton.icon(
                                onPressed: () =>
                                    showDialog(
                                      context: context,
                                      builder: (_) => RatingDialog(),
                                    ).then((result) {
                                      if (result != null && context.mounted) {
                                        context.read<AvaliacoesBloc>().add(
                                          AddAvaliacao(
                                            docenteId: widget.docenteId,
                                            rating: result['rating'],
                                            comentario: result['comentario'],
                                          ),
                                        );
                                      }
                                    }),
                                icon: Icon(Icons.rate_review),
                                label: const Text("Avaliar Professor"),
                              )
                            else
                              IconButton(
                                onPressed: () {},
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
                            title: Row(
                              children: List.generate(
                                5,
                                (i) => Icon(
                                  i < minhaAvaliacao.nota
                                      ? Icons.star
                                      : Icons.star_border,
                                ),
                              ),
                            ),
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
                      Text("Outras Avaliações", style: textTheme.titleMedium),
                      SliverList.builder(
                      itemCount: outrasAvaliacoes.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              i < outrasAvaliacoes[index].nota
                                  ? Icons.star
                                  : Icons.star_border,
                            ),
                          ),
                        ),
                        subtitle: outrasAvaliacoes[index].comentario != null
                            ? Text(
                                outrasAvaliacoes[index].comentario!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                      ),
                    ),
                    ],
                    
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
