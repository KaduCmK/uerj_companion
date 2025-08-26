import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/features/docentes/presentation/bloc/avaliacoes/avaliacoes_bloc.dart';
import 'package:uerj_companion/features/docentes/presentation/bloc/docentes/docentes_bloc.dart';
import 'package:uerj_companion/features/docentes/presentation/components/docente_avaliacoes_sliver.dart';
import 'package:uerj_companion/features/docentes/presentation/components/docente_profile_card.dart';
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            BlocConsumer<DocentesBloc, DocentesState>(
              listener: (context, state) {
                if (state is DocentesLoaded) context.pop();
              },
              builder: (context, state) {
                if (state is! DocenteProfileLoaded)
                  return const SliverToBoxAdapter();

                return SliverToBoxAdapter(
                  child: DocenteProfileCard(state: state),
                );
              },
            ),

            BlocConsumer<AvaliacoesBloc, AvaliacoesState>(
              listener: (context, state) {
                if (state is AvaliacaoEditing) {
                  showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: context.read<AvaliacoesBloc>(),
                      child: RatingDialog(),
                    ),
                  ).then((result) {
                    if (!context.mounted) return;

                    if (result == null) {
                      context.read<AvaliacoesBloc>().add(CancelEditing());
                      return;
                    }

                    context.read<AvaliacoesBloc>().add(
                      SetAvaliacao(
                        docenteId: widget.docenteId,
                        rating: result['rating'],
                        comentario: result['comentario'],
                      ),
                    );
                  });
                }
              },
              builder: (context, state) {
                if (state is! AvaliacoesDataState)
                  return const SliverToBoxAdapter(
                    child: LinearProgressIndicator(),
                  );

                return DocenteAvaliacoesSliver(state: state);
              },
            ),
          ],
        ),
      ),
    );
  }
}
