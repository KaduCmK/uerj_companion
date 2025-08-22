import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uerj_companion/features/docentes/domain/entities/docente.dart';
import 'package:uerj_companion/features/docentes/domain/entities/avaliacao.dart';

class DocenteRepository {
  final _docentesCollection = FirebaseFirestore.instance.collection('docentes');

  Future<void> upsertDocente(Docente docente) async {
    await _docentesCollection.doc(docente.id).set(docente.toMap(), SetOptions(merge: true));
  }

  Future<void> addAvaliacao(String docenteId, Avaliacao avaliacao) async {
    await _docentesCollection
        .doc(docenteId)
        .collection('avaliacoes')
        .add(avaliacao.toMap());
  }

  Future<List<Docente>> getDocentes() async {
    final snapshot = await _docentesCollection.orderBy('nome').get();
    return snapshot.docs.map((doc) => Docente.fromFirestore(doc)).toList();
  }

  Future<Docente> selectDocente(String docenteId) async {
    final snapshot = await _docentesCollection.doc(docenteId).get();
    return Docente.fromFirestore(snapshot);
  }

  Stream<List<Avaliacao>> getAvaliacoes(String docenteId) {
    return _docentesCollection
        .doc(docenteId)
        .collection('avaliacoes')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Avaliacao.fromFirestore(doc)).toList();
    });
  }
}