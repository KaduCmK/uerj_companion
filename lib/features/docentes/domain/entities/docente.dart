// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Docente extends Equatable {
  final String? id;
  final String nome;
  final String? email;
  final double mediaAvaliacoes;
  final String? resumoIA;
  final Timestamp? ultimaEdicaoIA;

  const Docente({
    this.id,
    required this.nome,
    this.email,
    this.mediaAvaliacoes = 0.0,
    this.resumoIA,
    this.ultimaEdicaoIA,
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
      ultimaEdicaoIA: data['ultimaEdicaoIA'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'mediaAvaliacoes': mediaAvaliacoes,
      'resumoIA': resumoIA,
      'ultimaEdicaoIA': ultimaEdicaoIA,
    };
  }

  Docente copyWith({
    String? id,
    String? nome,
    String? email,
    double? mediaAvaliacoes,
    String? resumoIA,
    Timestamp? ultimaEdicaoIA,
  }) {
    return Docente(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      mediaAvaliacoes: mediaAvaliacoes ?? this.mediaAvaliacoes,
      resumoIA: resumoIA ?? this.resumoIA,
      ultimaEdicaoIA: this.ultimaEdicaoIA,
    );
  }
}
