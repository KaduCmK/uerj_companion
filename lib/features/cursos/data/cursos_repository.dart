import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uerj_companion/features/cursos/domain/entities/curso.dart';
import 'package:uerj_companion/features/cursos/domain/entities/materia.dart';

class CursosRepository {
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
    await _cursosCollection
        .doc(curso.id)
        .set(curso.toMap(), SetOptions(merge: true));

    for (final materia in materias) {
      await _cursosCollection
          .doc(curso.id)
          .collection('materias')
          .doc(materia.id)
          .set(materia.toMap(), SetOptions(merge: true));
    }
  }
}
