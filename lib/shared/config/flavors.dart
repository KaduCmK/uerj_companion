enum FlavorTypes { dev, prod }

class Flavors {
  Flavors._instance();

  static late FlavorTypes flavorType;

  static String get flavorDisplayName {
    switch (flavorType) {
      case FlavorTypes.dev:
        return 'Dev';
      case FlavorTypes.prod:
        return 'Prod';
    }
  }

  static String get emailSignInRedirectUrl {
    switch (flavorType) {
      case FlavorTypes.dev:
        return 'http://localhost:8080';
      case FlavorTypes.prod:
        return 'https://uerj-companion.web.app';
    }
  }

  static bool isProduction() => flavorType == FlavorTypes.prod;
}
