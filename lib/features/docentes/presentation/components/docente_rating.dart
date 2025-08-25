import 'package:flutter/material.dart';

class DocenteRating extends StatelessWidget {
  final double rating;

  const DocenteRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(rating > i ? Icons.star : Icons.star_border),
      ),
    );
  }
}
