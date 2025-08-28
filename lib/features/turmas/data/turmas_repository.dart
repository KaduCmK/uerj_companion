import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uerj_companion/features/turmas/domain/periodo_helper.dart';
import 'package:uerj_companion/features/turmas/domain/turma.dart';

class TurmasRepository {
  final _periodosCollection = FirebaseFirestore.instance.collection('periodos');

  Future<List<Turma>> getTurmasDoPeriodo(String? periodo) async {
    final periodoId = periodo ?? PeriodoHelper.getCurrentPeriodo();
    final snapshot = await _periodosCollection
        .doc(periodoId)
        .collection('turmas')
        .get();

    return snapshot.docs.map((doc) => Turma.fromFirestore(doc)).toList();
  }

  Future<void> setTurma({String? periodo, required Turma turma}) async {
    final periodoId = periodo ?? PeriodoHelper.getCurrentPeriodo();
    await _periodosCollection
        .doc(periodoId)
        .collection('turmas')
        .doc(turma.id)
        .set(turma.toMap());
  }
}
