import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Materia extends Equatable {
  final String? id;
  final String nome;
  final String? codigo;

  const Materia({this.id, required this.nome, this.codigo});

  @override
  List<Object?> get props => [id, nome, codigo];

  factory Materia.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Materia(
      id: doc.id,
      nome: data['nome'] ?? "Sem nome",
      codigo: data['codigo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'nome': nome, 'codigo': codigo};
  }
}
