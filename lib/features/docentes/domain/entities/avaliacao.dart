import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Avaliacao extends Equatable {
  final String? id;
  final int rating;
  final String? text;
  final String? userId;
  final Timestamp createdAt;

  const Avaliacao({
    this.id,
    required this.rating,
    this.text,
    this.userId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, rating, text, userId, createdAt];

  factory Avaliacao.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Avaliacao(
      id: doc.id,
      rating: data['rating'],
      text: data['text'],
      userId: data['userId'],
      createdAt: data['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'text': text,
      'userId': userId,
      'created_at': createdAt,
    };
  }
}