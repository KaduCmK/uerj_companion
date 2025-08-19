import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Text(
              "Uerjiano",
              style: textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () => context.push('/login'),
              child: const Text("Entre com seu email universitário"),
            ),
            SizedBox(height: 16,),
            Text("Acesso rápido:", style: textTheme.titleMedium,),
            OutlinedButton(onPressed: () {}, child: Text("Informações de cursos"))
          ],
        ),
      ),
    );
  }
}
