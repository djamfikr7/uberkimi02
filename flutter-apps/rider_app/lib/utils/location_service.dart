import 'package:geolocator/geolocator.dart';
import 'package:rider_app/services/api_service.dart';
import 'dart:async';
import 'dart:math';

class LocationService {
  static bool _isTracking = false;
  static StreamSubscription<Position>? _positionStream;
  static String? _currentRideId;
  static Position? _lastPosition;
  static DateTime? _lastPositionTime;
  static int _fraudScore = 0;
  static Timer? _locationUpdateTimer; // Add timer for periodic updates

  // Start tracking location for a ride
  static Future<void> startLocationTracking(String rideId) async {
    _currentRideId = rideId;
    _isTracking = true;

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    // Start listening to position updates
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      if (_isTracking && _currentRideId != null) {
        _emitLocationUpdate(position);
      }
    });

    // Start periodic location updates (every 30 seconds)
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isTracking && _currentRideId != null) {
        // Get current location and send update
        getCurrentLocation().then((position) {
          _emitLocationUpdate(position);
        }).catchError((error) {
          print('Error getting current location: $error');
        });
      }
    });
  }

  // Stop tracking location
  static Future<void> stopLocationTracking() async {
    _isTracking = false;
    _currentRideId = null;
    await _positionStream?.cancel();
    _positionStream = null;
    _locationUpdateTimer?.cancel(); // Cancel the timer
    _locationUpdateTimer = null;
  }

  // Emit location update to server
  static void _emitLocationUpdate(Position position) {
    // Fraud detection
    if (_checkForFraud(position)) {
      print('⚠️ Potential fraud detected!');
      _fraudScore += 10;
      
      // If fraud score is too high, notify the server
      if (_fraudScore > 30) {
        print('🚨 High fraud risk detected!');
        // In a real implementation, we would notify the backend
      }
    }
    
    _lastPosition = position;
    _lastPositionTime = DateTime.now();
    
    // Send location update to API instead of socket
    if (_currentRideId != null) {
      ApiService().updateLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        rideId: _currentRideId!,
      ).catchError((error) {
        print('❌ Error updating location: $error');
      });
    }
  }
  
  // Check for potential fraud
  static bool _checkForFraud(Position position) {
    bool isFraud = false;
    
    // Check if this is the first position
    if (_lastPosition == null || _lastPositionTime == null) {
      return false;
    }
    
    final now = DateTime.now();
    final timeDiff = now.difference(_lastPositionTime!).inSeconds;
    
    // Don't check if less than 5 seconds have passed
    if (timeDiff < 5) {
      return false;
    }
    
    // Calculate distance between positions
    final distance = _calculateDistance(
      _lastPosition!.latitude, 
      _lastPosition!.longitude,
      position.latitude, 
      position.longitude
    );
    
    // Calculate speed (m/s)
    final speed = distance / timeDiff;
    
    // Check for impossible speeds (> 200 km/h or ~55 m/s)
    if (speed > 55) {
      print('⚠️ Impossible speed detected: ${speed.toStringAsFixed(2)} m/s');
      isFraud = true;
    }
    
    // Check for location jumps (> 100km in 5 seconds)
    if (distance > 100000) { // 100km
      print('⚠️ Large location jump detected: ${distance.toStringAsFixed(2)} meters');
      isFraud = true;
    }
    
    // Check if location services might be disabled
    if (position.accuracy > 1000) { // Poor accuracy
      print('⚠️ Poor location accuracy detected: ${position.accuracy.toStringAsFixed(2)} meters');
      isFraud = true;
    }
    
    return isFraud;
  }
  
  // Calculate distance between two coordinates (Haversine formula)
  static double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371e3; // Earth radius in meters
    final phi1 = lat1 * pi / 180;
    final phi2 = lat2 * pi / 180;
    final deltaPhi = (lat2 - lat1) * pi / 180;
    final deltaLambda = (lon2 - lon1) * pi / 180;
    
    final a = sin(deltaPhi/2) * sin(deltaPhi/2) +
            cos(phi1) * cos(phi2) *
            sin(deltaLambda/2) * sin(deltaLambda/2);
    final c = 2 * atan2(sqrt(a), sqrt(1-a));
    
    return R * c;
  }

  // Get current location once
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Check if currently tracking
  static bool isTracking() => _isTracking;
}