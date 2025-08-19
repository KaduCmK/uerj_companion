import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/features/cursos/domain/entities/curso.dart';
import 'package:uerj_companion/features/cursos/domain/entities/materia.dart';
import 'package:uerj_companion/features/cursos/presentation/curso_edit/bloc/curso_edit_bloc.dart';
import 'package:uerj_companion/shared/config/service_locator.dart';

class CursoEditScreen extends StatelessWidget {
  final Curso? curso;

  const CursoEditScreen({super.key, this.curso});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<CursoEditBloc>()..add(LoadCursoToEdit(curso)),
      child: BlocListener<CursoEditBloc, CursoEditState>(
        listener: (context, state) {
          if (state.status == CursoEditStatus.success) {
            context.pop();
          }
          if (state.status == CursoEditStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Erro: ${state.errorMessage}'),
                  backgroundColor: Theme.of(context).colorScheme.error),
            );
          }
        },
        child: _CursoEditView(),
      ),
    );
  }
}

class _CursoEditView extends StatefulWidget {
  @override
  __CursoEditViewState createState() => __CursoEditViewState();
}

class __CursoEditViewState extends State<_CursoEditView> {
  final _nomeCursoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<CursoEditBloc>().state;
    _nomeCursoController.text = state.cursoNome;
    _nomeCursoController.addListener(() {
      context
          .read<CursoEditBloc>()
          .add(UpdateCursoName(_nomeCursoController.text));
    });
  }

  @override
  void dispose() {
    _nomeCursoController.dispose();
    super.dispose();
  }

  void _showAddMateriaDialog(BuildContext context) {
    final nomeController = TextEditingController();
    final codigoController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Adicionar Matéria'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome da Matéria'),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo obrigatório' : null,
                ),
                TextFormField(
                  controller: codigoController,
                  decoration: const InputDecoration(labelText: 'Código'),
                  validator: (value) =>
                      value!.isEmpty ? 'Campo obrigatório' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final materia = Materia(
                    id: null,
                    nome: nomeController.text,
                    codigo: codigoController.text,
                  );
                  context.read<CursoEditBloc>().add(AddMateria(materia));
                  Navigator.of(dialogContext).pop();
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CursoEditBloc, CursoEditState>(
          builder: (context, state) {
            return Text(
                state.initialCurso == null ? 'Novo Curso' : 'Editar Curso');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () =>
                context.read<CursoEditBloc>().add(SaveCurso()),
          ),
        ],
      ),
      body: BlocBuilder<CursoEditBloc, CursoEditState>(
        builder: (context, state) {
          if (state.status == CursoEditStatus.loading || state.status == CursoEditStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
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
                    Text('Matérias',
                        style: Theme.of(context).textTheme.headlineSmall),
                    IconButton.filled(
                      icon: const Icon(Icons.add),
                      onPressed: () => _showAddMateriaDialog(context),
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
                            context
                                .read<CursoEditBloc>()
                                .add(RemoveMateria(materia));
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(SnackBar(
                                  content: Text(
                                      '${materia.nome} foi removida.')));
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