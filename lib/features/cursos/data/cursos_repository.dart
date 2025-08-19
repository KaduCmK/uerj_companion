import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uerj_companion/features/cursos/domain/entities/curso.dart';
import 'package:uerj_companion/features/cursos/domain/entities/materia.dart';

class CursosRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _cursosCollection = FirebaseFirestore.instance.collection('cursos');

  Future<List<Curso>> getCursos() async {
    final snapshot = await _cursosCollection.orderBy('nome').get();
    return snapshot.docs.map((doc) => Curso.fromFirestore(doc)).toList();
  }

  Future<List<Materia>> getMaterias(String cursoId) async {
    final snapshot = await _cursosCollection
        .doc(cursoId)
        .collection('materias')
        .orderBy('nome')
        .get();
    return snapshot.docs.map((doc) => Materia.fromFirestore(doc)).toList();
  }

  Future<void> saveCurso(Curso curso, List<Materia> materias) async {
    final batch = _firestore.batch();

    DocumentReference cursoRef;
    if (curso.id == null) {
      // Criando novo curso
      cursoRef = _cursosCollection.doc();
    } else {
      // Editando curso existente
      cursoRef = _cursosCollection.doc(curso.id);
    }
    batch.set(cursoRef, curso.toMap());

    // Deleta todas as matérias antigas para simplificar
    final materiasSnapshot = await cursoRef.collection('materias').get();
    for (var doc in materiasSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Adiciona as novas matérias
    for (var materia in materias) {
      final materiaRef = cursoRef.collection('materias').doc();
      batch.set(materiaRef, materia.toMap());
    }

    await batch.commit();
  }
}