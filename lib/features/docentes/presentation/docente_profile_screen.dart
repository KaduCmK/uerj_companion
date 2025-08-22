import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uerj_companion/features/docentes/presentation/bloc/docentes_bloc.dart';

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
      body: BlocBuilder<DocentesBloc, DocentesState>(
        builder: (context, state) {
          if (state is! DocenteProfileLoaded)
            return const Center(child: CircularProgressIndicator());

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
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
                          Row(mainAxisSize: MainAxisSize.min, children: List.generate(5, (_) => Icon(Icons.star_outline))),
                          Row(
                            spacing: 4,
                            children: [
                              Icon(Icons.email, size: 16),
                              Text(state.docente.email),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 8),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Avaliações:", style: textTheme.titleLarge),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.rate_review),
                          label: const Text("Avaliar Professor"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
