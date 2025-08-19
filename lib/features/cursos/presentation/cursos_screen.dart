import 'package:flutter/material.dart';

class CursosScreen extends StatelessWidget {
  const CursosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cursos e Matérias'),
        automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverToBoxAdapter(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: Text("Adicionar item"),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Text("Curso: "),
                  DropdownButton(
                    items: [
                      DropdownMenuItem(
                        child: const Text("Ciência da Computação"),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: TextField(
              decoration: const InputDecoration(hintText: "Pesquisar matérias"),
            ),
          ),

          SliverList.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return Placeholder();
            },
          ),
        ],
      ),
    );
  }
}
