import 'package:flutter/material.dart';
import 'package:uber_shared/map_widget.dart';

void main() {
  // Test Google Maps configuration
  print('Google Maps API Key: ${MapConfig.googleMapsApiKey}');
  print('Is Google Maps configured: ${MapConfig.isGoogleMapsConfigured()}');
  
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
      title: 'Google Maps Test',
      home: Scaffold(
        appBar: AppBar(title: const Text('Google Maps Test')),
        body: const UniversalMapWidget(
          latitude: 36.7213,
          longitude: 3.0376,
          zoom: 13.0,
          markers: [],
        ),
      ),
    );
  }
}