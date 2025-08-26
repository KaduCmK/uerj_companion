import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Center(
      child: Text(
        'Bem-vindo, ${user?.email ?? 'Visitante'}!',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}