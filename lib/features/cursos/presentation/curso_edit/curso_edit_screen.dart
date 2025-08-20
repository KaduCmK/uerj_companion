import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/features/cursos/presentation/curso_edit/bloc/curso_edit_bloc.dart';
import 'package:uerj_companion/features/cursos/presentation/curso_edit/new_materia_dialog.dart';

class CursoEditScreen extends StatelessWidget {
  const CursoEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CursoEditBloc, CursoEditState>(
      listener: (context, state) {
        if (state.status == CursoEditStatus.success) {
          context.pop();
        }
        if (state.status == CursoEditStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro: ${state.errorMessage}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: _CursoEditView(),
    );
  }
}

class _CursoEditView extends StatefulWidget {
  @override
  __CursoEditViewState createState() => __CursoEditViewState();
}

class __CursoEditViewState extends State<_CursoEditView> {
  late final TextEditingController _nomeCursoController;

  @override
  void initState() {
    super.initState();
    final state = context.read<CursoEditBloc>().state;
    _nomeCursoController = TextEditingController(text: state.cursoNome);
  }

  @override
  void dispose() {
    _nomeCursoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CursoEditBloc, CursoEditState>(
          builder: (context, state) {
            return Text(
              state.initialCurso == null ? 'Novo Curso' : 'Editar Curso',
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => context.read<CursoEditBloc>().add(SetCurso()),
          ),
        ],
      ),
      body: BlocBuilder<CursoEditBloc, CursoEditState>(
        builder: (context, state) {
          if (state.status == CursoEditStatus.loading ||
              state.status == CursoEditStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nomeCursoController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Curso',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Matérias',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton.filled(
                      icon: const Icon(Icons.add),
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => NewMateriaDialog(),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.materias.length,
                    itemBuilder: (context, index) {
                      final materia = state.materias[index];
                      return ListTile(
                        title: Text(materia.nome),
                        subtitle: Text(materia.codigo!),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context.read<CursoEditBloc>().add(
                              RemoveMateria(materia),
                            );
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${materia.nome} foi removida.',
                                  ),
                                ),
                              );
                          },
                        ),
                      );
                    },
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
