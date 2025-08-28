import 'package:intl/intl.dart';

class PeriodoHelper {
  static String getCurrentPeriodo() {
    final now = DateTime.now();
    final year = DateFormat('yyyy').format(now);
    final month = now.month;
    final semestre = (month <= 7) ? '1' : '2';
    
    return '$year.$semestre';
  }
}
