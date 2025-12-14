import 'package:flutter/material.dart';
import 'package:uber_shared/map_widget.dart';

void main() {
  // Test Google Maps configuration
  print('Google Maps API Key: ${MapConfig.googleMapsApiKey}');
  print('Is Google Maps configured: ${MapConfig.isGoogleMapsConfigured()}');
  
  // Test Mapbox configuration
  print('Mapbox Access Token: ${MapConfig.mapboxAccessToken}');
  print('Is Mapbox configured: ${MapConfig.isMapboxConfigured()}');
  
  // Test provider selection
  print('Current provider: ${MapConfig.currentProvider}');
  print('Selected provider: ${MapConfig.getCurrentProvider()}');
  
  // Create a simple app to test the map widget
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Fallback Test',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Map Fallback Test'),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Map Configuration Test',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text('Current Provider Setting: ${MapConfig.currentProvider}'),
              Text('Actual Provider Used: ${MapConfig.getCurrentProvider()}'),
              Text('Google Maps Configured: ${MapConfig.isGoogleMapsConfigured()}'),
              Text('Mapbox Configured: ${MapConfig.isMapboxConfigured()}'),
              const SizedBox(height: 16),
              const Text(
                'Map Display:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const UniversalMapWidget(
                    latitude: 36.7213,
                    longitude: 3.0376,
                    zoom: 13.0,
                    markers: [],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}