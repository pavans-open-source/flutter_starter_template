enum Flavor {
  dev,
  prod,
  uat;

  getServerUrl() {
    switch (this) {
      case dev:
        return '';
      case prod:
        return '';
      case uat:
        return '';
      default:
        return '';
    }
  }
}

class F {
  static Flavor? appFlavor;

  static String get serverUrl => appFlavor!.getServerUrl();

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'App Dev';
      case Flavor.prod:
        return 'App Prod';
      case Flavor.uat:
        return 'App UAT';
      default:
        return 'title';
    }
  }
}
