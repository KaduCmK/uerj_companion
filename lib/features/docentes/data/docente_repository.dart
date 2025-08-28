import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:uerj_companion/features/docentes/domain/entities/docente.dart';
import 'package:uerj_companion/features/docentes/domain/entities/avaliacao.dart';

class DocenteRepository {
  final _logger = Logger();
  final _docentesCollection = FirebaseFirestore.instance.collection('docentes');

  Future<void> upsertDocente(Docente docente) async {
    await _docentesCollection
        .doc(docente.id)
        .set(docente.toMap(), SetOptions(merge: true));
  }

  Future<void> upsertAvaliacao(String docenteId, Avaliacao avaliacao) async {
    await _docentesCollection
        .doc(docenteId)
        .collection('avaliacoes')
        .doc(avaliacao.userId)
        .set(avaliacao.toMap(), SetOptions(merge: true));
  }

  Future<List<Docente>> getDocentes() async {
    final snapshot = await _docentesCollection.orderBy('nome').get();
    return snapshot.docs.map((doc) => Docente.fromFirestore(doc)).toList();
  }

  Future<Docente> selectDocente(String docenteId) async {
    final snapshot = await _docentesCollection.doc(docenteId).get();
    return Docente.fromFirestore(snapshot);
  }

  Future<List<Avaliacao>> getAvaliacoes(String docenteId) async {
    final snapshot = await _docentesCollection
        .doc(docenteId)
        .collection('avaliacoes')
        .orderBy('created_at', descending: true)
        .get();
    final avaliacoes = snapshot.docs.map((doc) => Avaliacao.fromFirestore(doc)).toList();
    return avaliacoes;
  }
}
