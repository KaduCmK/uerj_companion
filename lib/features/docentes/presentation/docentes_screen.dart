import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uerj_companion/features/docentes/presentation/bloc/docentes_bloc.dart';

class DocentesScreen extends StatelessWidget {
  const DocentesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Docentes'),
        automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverToBoxAdapter(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Adicionar Docente"),
                onPressed: () {},
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverToBoxAdapter(
              child: TextField(
                decoration: const InputDecoration(labelText: "Buscar Docente"),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: BlocBuilder<DocentesBloc, DocentesState>(
              builder: (context, state) {
                if (state is! DocentesLoaded)
                  return const CircularProgressIndicator();

                if (state.docentes.isEmpty) return const Text("Nenhum docente");

                return ListView.builder(
                  itemCount: state.docentes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(state.docentes[index].nome),
                      subtitle: Text(state.docentes[index].email),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {},
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
