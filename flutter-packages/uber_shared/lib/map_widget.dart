import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

class UniversalMapWidget extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final double? zoom;
  final List<Marker>? markers;
  final VoidCallback? onMapTap;
  final String? preferredProvider; // Allow specifying preferred provider
  
  const UniversalMapWidget({
    super.key,
    this.latitude,
    this.longitude,
    this.zoom,
    this.markers,
    this.onMapTap,
    this.preferredProvider,
  });
  
  @override
  State<UniversalMapWidget> createState() => _UniversalMapWidgetState();
}

class _UniversalMapWidgetState extends State<UniversalMapWidget> {
  String _currentProvider = '';
  bool _mapLoadFailed = false;
  int _retryCount = 0;
  static const int _maxRetries = 2;
  
  @override
  void initState() {
    super.initState();
    _currentProvider = widget.preferredProvider ?? MapConfig.getCurrentProvider();
  }
  
  void _retryWithFallback() {
    if (_retryCount < _maxRetries) {
      setState(() {
        _retryCount++;
        _mapLoadFailed = false;
        
        // Try fallback providers in order
        if (_currentProvider == MapConfig.mapbox && _retryCount >= 1) {
          // Fall back to Google Maps if Mapbox fails
          _currentProvider = MapConfig.googleMaps;
        } else if ((_currentProvider == MapConfig.mapbox || _currentProvider == MapConfig.googleMaps) && _retryCount >= 2) {
          // Fall back to OpenStreetMap if both fail
          _currentProvider = MapConfig.openStreetMap;
        }
      });
    } else {
      setState(() {
        _mapLoadFailed = true;
      });
    }
  }
  
  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.map_outlined,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load map',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please check your internet connection or map configuration',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _retryWithFallback,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (_mapLoadFailed) {
      return _buildErrorWidget();
    }
    
    final lat = widget.latitude ?? MapConfig.defaultLatitude;
    final lng = widget.longitude ?? MapConfig.defaultLongitude;
    final mapZoom = widget.zoom ?? MapConfig.defaultZoom;
    
    try {
      if (_currentProvider == MapConfig.mapbox && MapConfig.isMapboxConfigured()) {
        // Mapbox implementation
        return FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(lat, lng),
            initialZoom: mapZoom,
            onTap: (_, __) => widget.onMapTap?.call(),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/256/{z}/{x}/{y}@2x?access_token=${MapConfig.mapboxAccessToken}',
              userAgentPackageName: 'com.uberclone.app',
              // Add subdomain support for better performance
              subdomains: const ['a', 'b', 'c'],
            ),
            if (widget.markers != null && widget.markers!.isNotEmpty)
              MarkerLayer(markers: widget.markers!),
          ],
        );
      } else if (_currentProvider == MapConfig.googleMaps && MapConfig.isGoogleMapsConfigured()) {
        // Google Maps implementation
        return FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(lat, lng),
            initialZoom: mapZoom,
            onTap: (_, __) => widget.onMapTap?.call(),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}&key=${MapConfig.googleMapsApiKey}',
              userAgentPackageName: 'com.uberclone.app',
              subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
            ),
            if (widget.markers != null && widget.markers!.isNotEmpty)
              MarkerLayer(markers: widget.markers!),
          ],
        );
      } else {
        // OpenStreetMap implementation with alternative URLs
        return FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(lat, lng),
            initialZoom: mapZoom,
            onTap: (_, __) => widget.onMapTap?.call(),
          ),
          children: [
            TileLayer(
              urlTemplate: MapConfig.openStreetMapTileUrl,
              userAgentPackageName: 'com.uberclone.app',
            ),
            if (widget.markers != null && widget.markers!.isNotEmpty)
              MarkerLayer(markers: widget.markers!),
          ],
        );
      }
    } catch (e) {
      // Handle general map loading errors
      print('Map loading error: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _retryWithFallback();
      });
      return _buildErrorWidget();
    }
  }
}