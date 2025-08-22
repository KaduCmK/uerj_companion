import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
    final state = (context.read<DocentesBloc>().state as DocenteEditing);
    _nomeController = TextEditingController(text: state.docente?.nome);
    _emailController = TextEditingController(text: state.docente?.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Docente'),
        leading: BackButton(
          onPressed: () => context.read<DocentesBloc>().add(GetDocentes()),
        ),
        actions: [
          IconButton(
            onPressed: () => context.read<DocentesBloc>().add(
              SetDocente(
                nome: _nomeController.text,
                email: _emailController.text,
              ),
            ),
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: BlocConsumer<DocentesBloc, DocentesState>(
        listener: (context, state) {
          if (state is DocentesLoaded) context.pop();
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
