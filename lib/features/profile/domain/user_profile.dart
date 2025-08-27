import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String? nome;
  final String email;
  final Timestamp createdAt;

  const UserProfile({this.nome, required this.email, required this.createdAt});

  @override
  List<Object?> get props => [nome, email, createdAt];

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    return UserProfile(
      nome: data?['nome'],
      email: data?['email'],
      createdAt: data?['createdAt'],
    );
  }
}
