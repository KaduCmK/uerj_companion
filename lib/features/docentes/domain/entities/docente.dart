import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Docente extends Equatable {
  final String? id;
  final String nome;
  final String email;
  final double mediaAvaliacoes;
  final String? resumoIA;

  const Docente({
    this.id,
    required this.nome,
    required this.email,
    this.mediaAvaliacoes = 0.0,
    this.resumoIA,
  });

  @override
  List<Object?> get props => [id, nome, email, mediaAvaliacoes, resumoIA];

  factory Docente.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Docente(
      id: doc.id,
      nome: data['nome'],
      email: data['email'],
      mediaAvaliacoes: (data['mediaAvaliacoes'] as num).toDouble(),
      resumoIA: data['resumoIA'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'mediaAvaliacoes': mediaAvaliacoes,
      'resumoIA': resumoIA,
    };
  }
}