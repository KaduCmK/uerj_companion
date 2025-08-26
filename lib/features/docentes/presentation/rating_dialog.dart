import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uerj_companion/features/docentes/presentation/bloc/avaliacoes/avaliacoes_bloc.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int rating = 0;
  final _comentarioController = TextEditingController();
  String? error;

  @override
  void initState() {
    super.initState();
    final state = context.read<AvaliacoesBloc>().state as AvaliacaoEditing;
    rating = state.avaliacaoToEdit?.nota ?? 0;
    _comentarioController.text = state.avaliacaoToEdit?.comentario ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: const Text('Avaliar professor'),
      content: Column(
        spacing: 2,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Dê uma nota de 1 a 5", style: textTheme.titleMedium),
          Row(
            children: List.generate(
              5,
              (i) => IconButton(
                onPressed: () => setState(() {
                  rating = i + 1;
                  error = null;
                }),
                iconSize: 40,
                icon: Icon(rating > i ? Icons.star : Icons.star_border),
              ),
            ),
          ),
          if (error != null)
            Text(
              error!,
              style: textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          const Divider(),
          Text("Deixe sua avaliação aqui.", style: textTheme.titleMedium),
          Text(
            'Inclua informações como cobra presença, reposição aberta, dificuldade da prova, etc.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          TextField(
            controller: _comentarioController,
            minLines: 3,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Deixe sua avaliação...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (rating == 0) {
              setState(() => error = 'É necessário dar uma nota de 1 a 5');
              return;
            }

            context.pop({
              'rating': rating,
              'comentario': _comentarioController.text,
            });
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
