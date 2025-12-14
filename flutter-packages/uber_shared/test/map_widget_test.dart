import 'package:flutter_test/flutter_test.dart';
import 'package:uber_shared/map_widget.dart';

void main() {
  test('MapConfig should have correct default values', () {
    expect(MapConfig.defaultLatitude, 36.7213);
    expect(MapConfig.defaultLongitude, 3.0376);
    expect(MapConfig.defaultZoom, 13.0);
  });

  test('MapConfig should fallback to OpenStreetMap when Mapbox is not configured', () {
    // Since we're not providing a Mapbox access token, it should fallback to OpenStreetMap
    expect(MapConfig.getCurrentProvider(), MapConfig.openStreetMap);
  });
}