import 'package:uerj_companion/shared/config/flavors.dart';
import 'main.dart' as main_common;

Future<void> main() async {
  Flavors.flavorType = FlavorTypes.prod;
  main_common.main();
}