import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/features/cursos/presentation/bloc/curso_bloc.dart';
import 'package:uerj_companion/shared/config/service_locator.dart';

class CursosScreen extends StatelessWidget {
  const CursosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CursoBloc>()..add(LoadCursos()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cursos e Matérias'),
          automaticallyImplyLeading: true,
        ),
        body: BlocBuilder<CursoBloc, CursoState>(
          builder: (context, state) {
            if (state is CursoLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CursosLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(8),
                    sliver: SliverToBoxAdapter(
                      child: ElevatedButton.icon(
                        onPressed: () => context.push('/edit-curso'),
                        icon: const Icon(Icons.add),
                        label: Text("Adicionar Curso"),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(8),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Text("Curso: "),
                          Expanded(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: state.selectedCursoId,
                              items: state.cursos.map((curso) {
                                return DropdownMenuItem<String>(
                                  value: curso.id,
                                  child: Text(curso.nome),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  context
                                      .read<CursoBloc>()
                                      .add(SelectCurso(value));
                                }
                              },
                            ),
                          ),
                          if (state.selectedCursoId != null)
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                final curso = state.cursos.firstWhere(
                                    (c) => c.id == state.selectedCursoId);
                                context.push('/edit-curso', extra: curso);
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                            hintText: "Pesquisar matérias"),
                      ),
                    ),
                  ),
                  SliverList.builder(
                    itemCount: state.materias.length,
                    itemBuilder: (context, index) {
                      final materia = state.materias[index];
                      return ListTile(
                        title: Text(materia.nome),
                        subtitle: Text(materia.codigo!),
                      );
                    },
                  ),
                ],
              );
            }
            if (state is CursosError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}