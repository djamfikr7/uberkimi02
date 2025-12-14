class Environment {
  /// API Base URL - can be overridden by environment variables
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3002/api',
  );

  /// Socket.io Base URL
  static const String socketBaseUrl = String.fromEnvironment(
    'SOCKET_BASE_URL',
    defaultValue: 'http://localhost:3002',
  );

  /// Use Mock Data - can be overridden by environment variables
  static const bool useMockData = bool.fromEnvironment(
    'USE_MOCK_DATA',
    defaultValue: false,
  );

  /// Debug Mode
  static const bool debugMode = bool.fromEnvironment(
    'DEBUG_MODE',
    defaultValue: true,
  );

  /// Environment Name
  static const String environmentName = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  /// Get configuration summary
  static Map<String, dynamic> getConfig() {
    return {
      'apiBaseUrl': apiBaseUrl,
      'socketBaseUrl': socketBaseUrl,
      'useMockData': useMockData,
      'debugMode': debugMode,
      'environmentName': environmentName,
    };
  }

  /// Print configuration (for debugging)
  static void printConfig() {
    if (debugMode) {
      print('📋 Environment Configuration:');
      print('  API Base URL: $apiBaseUrl');
      print('  Socket URL: $socketBaseUrl');
      print('  Use Mock Data: $useMockData');
      print('  Environment: $environmentName');
      print('  Debug Mode: $debugMode');
    }
  }
}