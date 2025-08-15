import 'package:uerj_companion/shared/config/flavors.dart';
import 'main.dart' as main_common;

Future<void> main() async {
  Flavors.flavorType = FlavorTypes.dev;
  main_common.main();
}
