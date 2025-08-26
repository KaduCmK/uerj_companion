import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/features/profile/domain/drawer_item.dart';

class ProfileScreen extends StatelessWidget {
  final Widget content;
  const ProfileScreen({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isAuthenticated = user != null;
    final currentLocation = GoRouterState.of(context).uri.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Uerjiano'),
        actions: [
          if (isAuthenticated)
            IconButton(
              icon: const CircleAvatar(child: Icon(Icons.person)),
              onPressed: () {
                if (!currentLocation.startsWith('/profile')) {
                  context.push('/profile');
                }
              },
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: FilledButton(
                onPressed: () => context.push('/login'),
                child: const Text('Login'),
              ),
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
            isAuthenticated
                ? OutlinedButton.icon(
                    onPressed: () {
                      context.pop();
                      if (!currentLocation.startsWith('/profile')) {
                        context.push('/profile');
                      }
                    },
                    icon: const Icon(Icons.person),
                    label: const Text('Seu Perfil'),
                  )
                : ElevatedButton.icon(
                    onPressed: () {
                      context.pop();
                      context.push('/login');
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Fazer Login'),
                  ),
            const Divider(height: 16),
            ...drawerItems.map((item) {
              final selected = currentLocation.startsWith(item.route);

              return ListTile(
                leading: Icon(item.icon),
                title: Text(item.title),
                selected: selected,
                onTap: () {
                  context.pop();
                  if (!selected) {
                    context.go(item.route);
                  }
                },
              );
            }),
          ],
        ),
      ),
      body: content,
    );
  }
}
