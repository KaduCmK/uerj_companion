import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Avaliacao extends Equatable {
  final String? id;
  final int nota;
  final String? comentario;
  final String? userId;
  final Timestamp timestamp;

  const Avaliacao({
    this.id,
    required this.nota,
    this.comentario,
    this.userId,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, nota, comentario, userId, timestamp];

  factory Avaliacao.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Avaliacao(
      id: doc.id,
      nota: data['nota'],
      comentario: data['comentario'],
      userId: data['userId'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nota': nota,
      'comentario': comentario,
      'userId': userId,
      'timestamp': timestamp,
    };
  }
}