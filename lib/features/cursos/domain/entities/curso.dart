import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Curso extends Equatable {
  final String? id;
  final String name;
  
  const Curso({
    this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];

  factory Curso.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Curso(
      id: doc.id,
      name: data['name'] ?? data['nome'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  Curso copyWith({
    String? id,
    String? name,
  }) {
    return Curso(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}