class DevConfig {
  /// Bypass authentication for development
  static const bool bypassAuth = true;

  /// Auto-login as demo user
  static const bool autoLoginDemoUser = true;

  /// Use mock data instead of real API calls
  static const bool useMockData = false;

  /// Enable debug logging
  static const bool enableDebugLogging = true;

  /// Default demo user type
  static const String defaultUserType = 'rider';
}