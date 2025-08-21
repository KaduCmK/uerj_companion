import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Curso extends Equatable {
  final String? id;
  final String nome;
  
  const Curso({
    this.id,
    required this.nome,
  });

  @override
  List<Object?> get props => [id, nome];

  factory Curso.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Curso(
      id: doc.id,
      nome: data['nome'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
    };
  }

  Curso copyWith({
    String? id,
    String? nome,
  }) {
    return Curso(
      id: id ?? this.id,
      nome: nome ?? this.nome,
    );
  }
}