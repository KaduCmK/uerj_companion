import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Uerjiano'),
        actions: [
          IconButton(
            icon: const CircleAvatar(),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(4),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Text(
                'Uerjiano',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {
                context.pop();
                context.push('/user-profile');
              },
              icon: const Icon(Icons.person),
              label: const Text('Seu Perfil'),
            ),
            const Divider(height: 16),
            ListTile(
              leading: Icon(Icons.home),
              title: const Text('Página Inicial'),
              onTap: () => context.go('/profile'),
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Cursos e Matérias'),
              onTap: () => context.push('/info-cursos'),
            ),
            ListTile(
              leading: const Icon(Icons.school,),
              title: const Text('Professores'),
              onTap: () => context.push('/docentes'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configurações'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Center(child: Text('Logado como: ${user?.email ?? 'Usuário'}')),
    );
  }
}
