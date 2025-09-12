import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uerj_companion/features/profile/domain/user_profile.dart';

class UserRepository {
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<UserProfile> getUserProfile(String userId) async {
    final snapshot = await _usersCollection.doc(userId).get();
    if (snapshot.exists) {
      return UserProfile.fromFirestore(snapshot);
    }
    else {
      throw Exception('User not found');
    }
  }
}