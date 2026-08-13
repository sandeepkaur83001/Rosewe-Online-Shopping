enum Environment { dev, staging, prod }

class EnvConfig {
  static Environment environment = Environment.dev;

  static String get baseUrl {
    switch (environment) {
      case Environment.dev:
        return 'http://162.241.68.61/rosewe/api/v1/';
      case Environment.staging:
        return 'http://162.241.68.61/rosewe/api/v1/';
      case Environment.prod:
        return 'http://162.241.68.61/rosewe/api/v1/';
    }
  }

  static String get baseUrlPhoto {
    switch (environment) {
      case Environment.dev:
        return 'https://dev-api.example.com/photos/';
      case Environment.staging:
        return 'https://staging-api.example.com/photos/';
      case Environment.prod:
        return 'https://api.example.com/photos/';
    }
  }

  static String get appTitle {
    switch (environment) {
      case Environment.dev:
        return 'Base App Dev';
      case Environment.staging:
        return 'Base App Staging';
      case Environment.prod:
        return 'Base App';
    }
  }

  static bool get isDebug => environment != Environment.prod;
}
