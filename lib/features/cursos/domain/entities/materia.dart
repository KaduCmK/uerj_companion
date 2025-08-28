import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Materia extends Equatable {
  final String? id;
  final String? name;
  final String? codigo;
  final String? whatsappGroupUrl;

  const Materia({this.id, this.name, this.codigo, this.whatsappGroupUrl});

  @override
  List<Object?> get props => [id, name, codigo];

  factory Materia.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Materia(
      id: doc.id,
      name: data['name'],
      codigo: data['codigo'],
      whatsappGroupUrl: data['whatsappGroupUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'codigo': codigo,
      'whatsappGroupUrl': whatsappGroupUrl,
    };
  }
}
