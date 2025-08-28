import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uerj_companion/features/docentes/domain/entities/avaliacao.dart';
import 'package:uerj_companion/features/docentes/presentation/components/docente_rating.dart';

class AvaliacaoCard extends StatelessWidget {
  final Avaliacao avaliacao;
  final bool highlight;
  const AvaliacaoCard({
    super.key,
    required this.avaliacao,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card.outlined(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DocenteRating(rating: avaliacao.rating.toDouble()),
            Text(
              DateFormat('dd/MM/yyyy').format(avaliacao.createdAt.toDate()),
              style: textTheme.labelMedium,
            ),
          ],
        ),
        subtitle: avaliacao.text != null
            ? Text(
                avaliacao.text!,
              )
            : null,
      ),
    );
  }
}
