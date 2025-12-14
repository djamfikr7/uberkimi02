void main() {
  // Test Google Maps configuration
  const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: 'AIzaSyBZakrSM90wtSim8ZwgRVZEPbmxth7h6ig',
  );
  
  // Test Mapbox configuration
  const String mapboxAccessToken = String.fromEnvironment(
    'MAPBOX_ACCESS_TOKEN',
    defaultValue: '',
  );
  
  // Check if Google Maps is properly configured
  bool isGoogleMapsConfigured() {
    // Check if it's a valid API key (not the default placeholder)
    return googleMapsApiKey.isNotEmpty && 
           googleMapsApiKey != 'YOUR_GOOGLE_MAPS_API_KEY' && 
           googleMapsApiKey.length > 20 && // Valid API keys are typically longer
           !googleMapsApiKey.contains('AIzaSyBZakrSM90wtSim8ZwgRVZEPbmxth7h6ig'); // Not the default placeholder
  }
  
  // Check if Mapbox is properly configured
  bool isMapboxConfigured() {
    return mapboxAccessToken.isNotEmpty && mapboxAccessToken != 'YOUR_MAPBOX_ACCESS_TOKEN';
  }
  
  // Current map provider setting
  const String currentProvider = 'googlemaps'; // Change this to test different providers
  
  // Get current provider (fallback to OpenStreetMap if primary provider not configured)
  String getCurrentProvider() {
    if (currentProvider == 'mapbox' && isMapboxConfigured()) {
      return 'mapbox';
    }
    if (currentProvider == 'googlemaps' && isGoogleMapsConfigured()) {
      return 'googlemaps';
    }
    return 'openstreetmap';
  }
  
  print('=== Map Configuration Test ===');
  print('Google Maps API Key: $googleMapsApiKey');
  print('Is Google Maps configured: ${isGoogleMapsConfigured()}');
  print('Mapbox Access Token: $mapboxAccessToken');
  print('Is Mapbox configured: ${isMapboxConfigured()}');
  print('Current provider setting: $currentProvider');
  print('Actual provider that will be used: ${getCurrentProvider()}');
  print('================================');
  
  // Test with a valid Google Maps API key
  print('\n--- Testing with valid Google Maps API key ---');
  const String validGoogleMapsApiKey = 'AIzaSyValidApiKey1234567890abcdefghij';
  bool isValidGoogleMapsConfigured = validGoogleMapsApiKey.isNotEmpty && 
           validGoogleMapsApiKey != 'YOUR_GOOGLE_MAPS_API_KEY' && 
           validGoogleMapsApiKey.length > 20 && 
           !validGoogleMapsApiKey.contains('AIzaSyBZakrSM90wtSim8ZwgRVZEPbmxth7h6ig');
           
  print('Valid Google Maps API Key: $validGoogleMapsApiKey');
  print('Is Valid Google Maps configured: $isValidGoogleMapsConfigured');
  
  // Test with invalid Google Maps API key (placeholder)
  print('\n--- Testing with invalid Google Maps API key (placeholder) ---');
  const String invalidGoogleMapsApiKey = 'AIzaSyBZakrSM90wtSim8ZwgRVZEPbmxth7h6ig';
  bool isInvalidGoogleMapsConfigured = invalidGoogleMapsApiKey.isNotEmpty && 
           invalidGoogleMapsApiKey != 'YOUR_GOOGLE_MAPS_API_KEY' && 
           invalidGoogleMapsApiKey.length > 20 && 
           !invalidGoogleMapsApiKey.contains('AIzaSyBZakrSM90wtSim8ZwgRVZEPbmxth7h6ig');
           
  print('Invalid Google Maps API Key: $invalidGoogleMapsApiKey');
  print('Is Invalid Google Maps configured: $isInvalidGoogleMapsConfigured');
}