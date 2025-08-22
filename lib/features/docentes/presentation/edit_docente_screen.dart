import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uerj_companion/features/docentes/presentation/bloc/docentes_bloc.dart';

class EditDocenteScreen extends StatefulWidget {
  const EditDocenteScreen({super.key});

  @override
  State<EditDocenteScreen> createState() => _EditDocenteScreenState();
}

class _EditDocenteScreenState extends State<EditDocenteScreen> {
  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Docente'),
        actions: [
          IconButton(
            onPressed: () => context.read<DocentesBloc>().add(SetDocente()),
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: BlocConsumer<DocentesBloc, DocentesState>(
        listener: (context, state) {
          if (state is DocenteEditing) {
            _nomeController.text = state.docente.nome;
            _emailController.text = state.docente.email;
          }
        },
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome do Docente',
                  ),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Institucional',
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
