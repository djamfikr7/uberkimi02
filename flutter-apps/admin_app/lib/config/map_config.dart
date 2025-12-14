class MapConfig {
  /// Map provider options
  static const String openStreetMap = 'openstreetmap';
  static const String mapbox = 'mapbox';
  
  /// Current map provider (change this to switch providers)
  static const String currentProvider = mapbox;
  
  /// Mapbox configuration
  static const String mapboxAccessToken = String.fromEnvironment(
    'MAPBOX_ACCESS_TOKEN',
    defaultValue: '',
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
  
  /// Default location (Algiers coordinates)
  static const double defaultLatitude = 36.7213;
  static const double defaultLongitude = 3.0376;
  static const double defaultZoom = 13.0;
  
  /// Check if Mapbox is properly configured
  static bool isMapboxConfigured() {
    return mapboxAccessToken.isNotEmpty;
  }
  
  /// Get current provider (fallback to OpenStreetMap if Mapbox not configured)
  static String getCurrentProvider() {
    if (currentProvider == mapbox && isMapboxConfigured()) {
      return mapbox;
    }
    return openStreetMap;
  }
}