import 'dart:async';
import 'package:flutter/material.dart';

class TypewriterFadeText extends StatefulWidget {
  final String text;
  final Duration wordDuration;
  final Duration fadeDuration;
  final TextStyle? style;

  const TypewriterFadeText({
    super.key,
    required this.text,
    this.wordDuration = const Duration(milliseconds: 10),
    this.fadeDuration = const Duration(milliseconds: 150),
    this.style,
  });

  @override
  State<TypewriterFadeText> createState() => _TypewriterFadeTextState();
}

class _TypewriterFadeTextState extends State<TypewriterFadeText> {
  final List<String> _typedWords = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    final words = widget.text.split(RegExp(r'\s+'));
    int currentIndex = 0;

    _timer = Timer.periodic(widget.wordDuration, (timer) {
      if (currentIndex < words.length) {
        if (mounted) {
          setState(() {
            _typedWords.add(words[currentIndex]);
          });
        }
        currentIndex++;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTextStyle = widget.style ?? Theme.of(context).textTheme.bodyMedium;

    // Geramos a lista de widgets (palavra + espaço)
    final List<Widget> wordWidgets = _typedWords.expand((word) {
      return [
        // Nosso novo widget que cuida do fade individual
        _FadeInWord(
          word: word,
          duration: widget.fadeDuration,
          style: effectiveTextStyle,
        ),
        Text(' ', style: effectiveTextStyle),
      ];
    }).toList();

    return Wrap(
      children: wordWidgets,
    );
  }
}

// Widget auxiliar que cuida do fade de CADA palavra
class _FadeInWord extends StatefulWidget {
  final String word;
  final Duration duration;
  final TextStyle? style;

  const _FadeInWord({
    required this.word,
    required this.duration,
    this.style,
  });

  @override
  State<_FadeInWord> createState() => _FadeInWordState();
}

class _FadeInWordState extends State<_FadeInWord> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Força a animação a começar assim que o widget é construído
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: widget.duration,
      child: Text(widget.word, style: widget.style),
    );
  }
}