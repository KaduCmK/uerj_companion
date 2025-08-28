import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/features/cursos/domain/entities/materia.dart';
import 'package:uerj_companion/features/cursos/presentation/curso_edit/bloc/curso_edit_bloc.dart';

class NewMateriaDialog extends StatefulWidget {
  const NewMateriaDialog({super.key});

  @override
  State<NewMateriaDialog> createState() => _NewMateriaDialogState();
}

class _NewMateriaDialogState extends State<NewMateriaDialog> {
  final nomeController = TextEditingController();
  final codigoController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
            TextFormField(
              controller: codigoController,
              decoration: const InputDecoration(labelText: 'Código'),
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final materia = Materia(
                name: nomeController.text,
                codigo: codigoController.text,
              );
              context.read<CursoEditBloc>().add(AddMateria(materia));
              context.pop();
            }
          },
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}
