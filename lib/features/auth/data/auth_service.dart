import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uerj_companion/features/cursos/domain/entities/curso.dart';
import 'package:uerj_companion/shared/config/flavors.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const _emailKey = 'user_email';

  User? get currentUser => _auth.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDocument() {
    return _firestore.collection('users').doc(currentUser?.uid).get();
  }

  Future<void> signInAnonymously() async => _auth.signInAnonymously();

  Future<void> completeOnboarding(Curso? curso) async {
    await _firestore.collection('users').doc(currentUser?.uid).set({
      'onboardingComplete': true,
      'cursoId': _firestore.collection('cursos').doc(curso?.id),
    }, SetOptions(merge: true));
  }

  Future<void> _saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  Future<String?> _getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  Future<void> sendSignInLink(String email) async {
    await _auth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        url: Flavors.emailSignInRedirectUrl,
        handleCodeInApp: true,
      ),
    );
    await _saveEmail(email);
  }

  bool isSignInLink(String link) => _auth.isSignInWithEmailLink(link);

  // Processa o link quando o app é aberto
  Future<void> handleSignInLink(Uri uri) async {
    final email = await _getEmail();
    if (email == null) {
      throw FirebaseAuthException(
        code: 'email-not-found',
        message: 'Erro: email não encontrado para completar o login.',
      );
    }

    if (_auth.isSignInWithEmailLink(uri.toString())) {
      await _auth.signInWithEmailLink(email: email, emailLink: uri.toString());
    }
  }
}
