import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Turma extends Equatable {
  final String? id;
  final DocumentReference materia;
  final List<DocumentReference> docentes;
  final int vagas;

  const Turma({
    this.id,
    required this.materia,
    required this.docentes,
    required this.vagas,
  });

  @override
  List<Object?> get props => [id, materia, docentes, vagas];

  Map<String, dynamic> toMap() {
    return {
      'materia': materia,
      'docentes': docentes,
      'vagas': vagas,
    };
  }

  factory Turma.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Turma(
      id: doc.id,
      materia: data['materia'],
      docentes: List<DocumentReference>.from(data['docentes']),
      vagas: data['vagas'],
    );
  }
}