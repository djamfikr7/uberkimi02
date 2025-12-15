import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uber_shared/uber_shared.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

void main() {
  group('EnhancedMapWidget', () {
    testWidgets('renders correctly with default properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedMapWidget(),
          ),
        ),
      );

      expect(find.byType(EnhancedMapWidget), findsOneWidget);
    });

    testWidgets('renders with custom coordinates', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedMapWidget(
              latitude: 36.752887,
              longitude: 3.042048,
              zoom: 15.0,
            ),
          ),
        ),
      );

      expect(find.byType(EnhancedMapWidget), findsOneWidget);
    });

    testWidgets('renders with markers', (WidgetTester tester) async {
      final markers = [
        Marker(
          point: LatLng(36.752887, 3.042048),
          child: const Icon(Icons.location_on),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedMapWidget(
              markers: markers,
            ),
          ),
        ),
      );

      expect(find.byType(EnhancedMapWidget), findsOneWidget);
    });

    testWidgets('renders with polylines', (WidgetTester tester) async {
      final polylines = [
        Polyline(
          points: [
            LatLng(36.752887, 3.042048),
            LatLng(36.753887, 3.043048),
          ],
          color: Colors.blue,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedMapWidget(
              polylines: polylines,
            ),
          ),
        ),
      );

      expect(find.byType(EnhancedMapWidget), findsOneWidget);
    });

    testWidgets('shows animated markers when enabled', (WidgetTester tester) async {
      final markers = [
        Marker(
          point: LatLng(36.752887, 3.042048),
          child: const Icon(Icons.location_on),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedMapWidget(
              markers: markers,
              showAnimatedMarkers: true,
            ),
          ),
        ),
      );

      expect(find.byType(EnhancedMapWidget), findsOneWidget);
    });

    testWidgets('shows regular markers when animation disabled', (WidgetTester tester) async {
      final markers = [
        Marker(
          point: LatLng(36.752887, 3.042048),
          child: const Icon(Icons.location_on),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedMapWidget(
              markers: markers,
              showAnimatedMarkers: false,
            ),
          ),
        ),
      );

      expect(find.byType(EnhancedMapWidget), findsOneWidget);
    });

    testWidgets('handles map tap callback', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EnhancedMapWidget(
              onMapTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.byType(EnhancedMapWidget), findsOneWidget);
      // Note: We can't easily simulate a map tap in tests without access to the internal FlutterMap widget
    });
  });
}