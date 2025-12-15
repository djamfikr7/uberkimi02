import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:uber_shared/widgets/animated_map_marker.dart';
import 'package:uber_shared/theme/app_theme.dart';

/// Enhanced map widget with animated markers and improved visualization
class EnhancedMapWidget extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final double? zoom;
  final List<Marker>? markers;
  final List<Polyline>? polylines;
  final VoidCallback? onMapTap;
  final bool showAnimatedMarkers;

  const EnhancedMapWidget({
    Key? key,
    this.latitude,
    this.longitude,
    this.zoom,
    this.markers,
    this.polylines,
    this.onMapTap,
    this.showAnimatedMarkers = true,
  }) : super(key: key);

  @override
  State<EnhancedMapWidget> createState() => _EnhancedMapWidgetState();
}

class _EnhancedMapWidgetState extends State<EnhancedMapWidget> {
  List<Marker> _getEnhancedMarkers() {
    if (widget.markers == null || !widget.showAnimatedMarkers) {
      return widget.markers ?? [];
    }

    return widget.markers!.map((marker) {
      // Extract position from the original marker
      final position = marker.point;
      
      // Create animated marker
      return Marker(
        point: position,
        width: marker.width ?? 40,
        height: marker.height ?? 40,
        child: AnimatedMapMarker(
          size: marker.width ?? 40,
          color: _getMarkerColor(marker),
          isPulsing: _shouldPulse(marker),
        ),
      );
    }).toList();
  }

  Color _getMarkerColor(Marker marker) {
    // Try to extract color from the original marker child
    if (marker.child is Icon) {
      final icon = marker.child as Icon;
      return icon.color ?? AppTheme.primaryLight;
    }
    return AppTheme.primaryLight;
  }

  bool _shouldPulse(Marker marker) {
    // Make pickup and driver markers pulse
    if (marker.child is Icon) {
      final icon = marker.child as Icon;
      return icon.icon == Icons.location_on || icon.icon == Icons.directions_car;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final lat = widget.latitude ?? 36.752887;
    final lng = widget.longitude ?? 3.042048;
    final mapZoom = widget.zoom ?? 13.0;
    
    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(lat, lng),
        initialZoom: mapZoom,
        onTap: (_, __) => widget.onMapTap?.call(),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.uberclone.app',
        ),
        if (widget.polylines != null && widget.polylines!.isNotEmpty)
          PolylineLayer(
            polylines: widget.polylines!,
          ),
        MarkerLayer(
          markers: _getEnhancedMarkers(),
        ),
      ],
    );
  }
}