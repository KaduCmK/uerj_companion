import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/features/docentes/presentation/bloc/docentes/docentes_bloc.dart';

class DocentesScreen extends StatelessWidget {
  const DocentesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Docentes'),
        automaticallyImplyLeading: true,
      ),
      body: BlocListener<DocentesBloc, DocentesState>(
        listener: (context, state) {
          if (state is DocenteEditing) {
            context.push('/edit-docente');
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverToBoxAdapter(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Adicionar Docente"),
                  onPressed: () =>
                      context.read<DocentesBloc>().add(EditDocente()),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverToBoxAdapter(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: "Buscar Docente",
                  ),
                ),
              ),
            ),
            BlocBuilder<DocentesBloc, DocentesState>(
              builder: (context, state) {
                if (state is! DocentesLoaded) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state.docentes.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("Nenhum docente"),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final docente = state.docentes[index];
                    return ListTile(
                      title: Text(docente.nome),
                      subtitle: Text(docente.email),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => context.read<DocentesBloc>().add(
                          EditDocente(docente: docente),
                        ),
                      ),
                      onTap: () => context.push('/docente/${docente.id}'),
                    );
                  }, childCount: state.docentes.length),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
