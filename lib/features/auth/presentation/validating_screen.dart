import 'package:flutter/material.dart';

class ValidatingScreen extends StatelessWidget {
  const ValidatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Validando seu login, só um momento...'),
          ],
        ),
      ),
    );
  }
}