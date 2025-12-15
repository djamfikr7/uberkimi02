class MapConfig {
  /// Map provider options
  static const String openStreetMap = 'openstreetmap';
  static const String mapbox = 'mapbox';
  static const String googleMaps = 'googlemaps';
  
  /// Current map provider (change this to switch providers)
  static const String currentProvider = googleMaps;
  
  /// Mapbox configuration
  static const String mapboxAccessToken = String.fromEnvironment(
    'MAPBOX_ACCESS_TOKEN',
    defaultValue: '',
  );
  
  /// Google Maps configuration
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: 'AIzaSyBZakrSM90wtSim8ZwgRVZEPbmxth7h6ig',
  );
  
  /// Mapbox style URLs
  static const String mapboxStreets = 'mapbox://styles/mapbox/streets-v11';
  static const String mapboxOutdoors = 'mapbox://styles/mapbox/outdoors-v11';
  static const String mapboxLight = 'mapbox://styles/mapbox/light-v10';
  static const String mapboxDark = 'mapbox://styles/mapbox/dark-v10';
  static const String mapboxSatellite = 'mapbox://styles/mapbox/satellite-v9';
  static const String mapboxSatelliteStreets = 'mapbox://styles/mapbox/satellite-streets-v11';
  
  /// Current Mapbox style
  static const String mapboxStyle = mapboxStreets;
  
  /// OpenStreetMap tile URL
  static const String openStreetMapTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  
  /// Alternative OpenStreetMap tile URLs for redundancy
  static const List<String> openStreetMapAlternativeUrls = [
    'https://a.tile.openstreetmap.org/{z}/{x}/{y}.png',
    'https://b.tile.openstreetmap.org/{z}/{x}/{y}.png',
    'https://c.tile.openstreetmap.org/{z}/{x}/{y}.png',
  ];
  
  /// Default location (Algiers coordinates)
  static const double defaultLatitude = 36.7213;
  static const double defaultLongitude = 3.0376;
  static const double defaultZoom = 13.0;
  
  /// Check if Mapbox is properly configured
  static bool isMapboxConfigured() {
    return mapboxAccessToken.isNotEmpty && mapboxAccessToken != 'YOUR_MAPBOX_ACCESS_TOKEN';
  }
  
  /// Check if Google Maps is properly configured
  static bool isGoogleMapsConfigured() {
    // Check if it's a valid API key (not the default placeholder)
    return googleMapsApiKey.isNotEmpty && 
           googleMapsApiKey != 'YOUR_GOOGLE_MAPS_API_KEY' && 
           googleMapsApiKey.length > 20 && // Valid API keys are typically longer
           !googleMapsApiKey.contains('AIzaSyBZakrSM90wtSim8ZwgRVZEPbmxth7h6ig'); // Not the default placeholder
  }
  
  /// Get current provider (fallback to OpenStreetMap if primary provider not configured)
  static String getCurrentProvider() {
    if (currentProvider == mapbox && isMapboxConfigured()) {
      return mapbox;
    }
    if (currentProvider == googleMaps && isGoogleMapsConfigured()) {
      return googleMaps;
    }
    return openStreetMap;
  }
  
  /// Test function to verify Google Maps configuration
  static void testGoogleMapsConfig() {
    print('=== Google Maps Configuration Test ===');
    print('API Key: $googleMapsApiKey');
    print('Key Length: ${googleMapsApiKey.length}');
    print('Is Configured: ${isGoogleMapsConfigured()}');
    print('=====================================');
  }
}