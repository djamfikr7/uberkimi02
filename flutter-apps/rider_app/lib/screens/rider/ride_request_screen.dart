import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:latlong2/latlong.dart';
import 'package:rider_app/theme/app_theme.dart';
import 'package:rider_app/services/api_service.dart';
import 'package:rider_app/utils/location_service.dart';
import 'package:uber_shared/map_widget.dart';
import 'package:rider_app/screens/rider/rating_screen.dart'; // Add this import
import 'package:rider_app/screens/rider/chat_screen.dart'; // Add this import
import 'dart:async';

class RideRequestScreen extends StatefulWidget {
  const RideRequestScreen({super.key});

  @override
  State<RideRequestScreen> createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropoffController = TextEditingController();
  LatLng? _pickupLocation;
  LatLng? _dropoffLocation;
  String _selectedVehicleType = 'uber-x';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Set default locations (Algiers coordinates)
    _pickupLocation = const LatLng(36.7213, 3.0376);
    _dropoffLocation = const LatLng(36.7213, 3.0376);
    _pickupController.text = 'Current Location';
    _dropoffController.text = 'Enter destination';
  }

  Future<void> _requestRide() async {
    if (_dropoffLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a destination'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final rideData = {
        'pickupLocation': {
          'lat': _pickupLocation!.latitude,
          'lng': _pickupLocation!.longitude,
        },
        'dropoffLocation': {
          'lat': _dropoffLocation!.latitude,
          'lng': _dropoffLocation!.longitude,
        },
        'pickupAddress': _pickupController.text,
        'dropoffAddress': _dropoffController.text,
        'vehicleType': _selectedVehicleType,
        'baseFare': 15.0, // Placeholder fare
      };

      final response = await ApiService().requestRide(rideData);
      
      if (response['success']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ride requested successfully!'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          
          // Navigate to ride tracking screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RideTrackingScreen(rideId: response['data']['ride']['id']),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Failed to request ride'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error requesting ride: ${error.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Ride'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Map View
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: UniversalMapWidget(
                latitude: _pickupLocation?.latitude ?? MapConfig.defaultLatitude,
                longitude: _pickupLocation?.longitude ?? MapConfig.defaultLongitude,
                zoom: 13.0,
                markers: [
                  if (_pickupLocation != null)
                    flutter_map.Marker(
                      point: _pickupLocation!,
                      child: const Icon(Icons.location_on, color: Colors.blue, size: 30),
                    ),
                  if (_dropoffLocation != null)
                    flutter_map.Marker(
                      point: _dropoffLocation!,
                      child: const Icon(Icons.location_on, color: Colors.red, size: 30),
                    ),
                ],
                polylines: [
                  if (_pickupLocation != null && _dropoffLocation != null)
                    flutter_map.Polyline(
                      points: MapConfig.generateCurvedRoute(_pickupLocation!, _dropoffLocation!),
                      color: AppTheme.primaryColor,
                      strokeWidth: 4.0,
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Location Inputs
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Pickup Location
                    TextFormField(
                      controller: _pickupController,
                      decoration: const InputDecoration(
                        labelText: 'Pickup Location',
                        prefixIcon: Icon(Icons.circle, color: Colors.blue),
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: () {
                        // TODO: Implement location picker
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Location picker coming soon')),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Dropoff Location
                    TextFormField(
                      controller: _dropoffController,
                      decoration: const InputDecoration(
                        labelText: 'Dropoff Location',
                        prefixIcon: Icon(Icons.location_on, color: Colors.red),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        // TODO: Implement location search
                        if (value.isNotEmpty) {
                          setState(() {
                            _dropoffLocation = const LatLng(36.75, 3.05); // Placeholder
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Vehicle Selection
            const Text(
              'Select Vehicle Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 8),
            
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildVehicleOption('UberX', 'Affordable', '\$12-18', Icons.car_crash, 'uber-x'),
                  _buildVehicleOption('Comfort', 'Extra legroom', '\$18-25', Icons.airline_seat_recline_extra, 'comfort'),
                  _buildVehicleOption('Black', 'Premium', '\$25-35', Icons.local_taxi, 'black'),
                  _buildVehicleOption('Pool', 'Shared ride', '\$8-12', Icons.people, 'pool'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Fare Estimate
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Fare Estimate',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '\$15.00',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This is an estimate. Actual fare may vary.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Request Ride Button
            ElevatedButton(
              onPressed: _isLoading ? null : _requestRide,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text(
                      'Request Ride',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildVehicleOption(String title, String subtitle, String price, IconData icon, String type) {
    final isSelected = _selectedVehicleType == type;
    
    return GestureDetector(
      onTap: () {
        setState(() => _selectedVehicleType = type);
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withValues(alpha: 0.2) : AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: isSelected ? AppTheme.primaryColor : Colors.grey),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.primaryColor : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// Ride Tracking Screen
class RideTrackingScreen extends StatefulWidget {
  final String rideId;
  
  const RideTrackingScreen({super.key, required this.rideId});

  @override
  State<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen> {
  Map<String, dynamic>? _ride;
  bool _isLoading = true;
  List<flutter_map.Marker> _markers = [];
  LatLng? _riderLocation;
  LatLng? _driverLocation;
  Timer? _timeoutTimer;
  Timer? _locationUpdateTimer; // Add timer for periodic location updates
  bool _isLate = false;
  
  @override
  void initState() {
    super.initState();
    _loadRideDetails();
    _setupLocationTracking();
    _startTimeoutTimer();
    // Start periodic location updates (every 30 seconds)
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _loadRideDetails();
    });
  }

  @override
  void dispose() {
    // Stop location tracking when screen is disposed
    LocationService.stopLocationTracking();
    ApiService().unregisterLocationListener(_handleLocationUpdate);
    ApiService().unregisterRideStatusListener(_handleRideStatusUpdate);
    _timeoutTimer?.cancel();
    _locationUpdateTimer?.cancel(); // Cancel the location update timer
    super.dispose();
  }
  
  void _setupLocationTracking() {
    // Register for location updates
    ApiService().registerLocationListener(_handleLocationUpdate);
    
    // Register for ride status updates
    ApiService().registerRideStatusListener(_handleRideStatusUpdate);
    
    // Start location tracking for this ride
    LocationService.startLocationTracking(widget.rideId);
  }
  
  void _startTimeoutTimer() {
    // Start a timer to check for late arrivals (15 minutes)
    _timeoutTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (_ride != null && _ride!['status'] == 'accepted') {
        final createdAt = DateTime.parse(_ride!['createdAt']);
        final now = DateTime.now();
        final difference = now.difference(createdAt);
        
        // If more than 15 minutes have passed since ride was accepted
        if (difference.inMinutes > 15) {
          setState(() {
            _isLate = true;
          });
          
          // Show notification
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Driver is taking longer than expected. Please contact support if needed.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
          
          // Cancel the timer after showing the notification once
          timer.cancel();
        }
      }
    });
  }
  
  void _handleLocationUpdate(dynamic data) {
    if (data is Map<String, dynamic> && data['rideId'] == widget.rideId) {
      setState(() {
        if (data.containsKey('latitude') && data.containsKey('longitude')) {
          // Update driver location
          _driverLocation = LatLng(data['latitude'], data['longitude']);
          _updateMarkers();
        }
      });
    } else if (data is Map<String, dynamic> && 
               data.containsKey('latitude') && 
               data.containsKey('longitude') &&
               data.containsKey('userType') &&
               data['userType'] == 'rider') {
      // This is a rider location update
      setState(() {
        _riderLocation = LatLng(data['latitude'], data['longitude']);
        _updateMarkers();
      });
    }
  }
  
  void _handleRideStatusUpdate(dynamic data) {
    if (data is Map<String, dynamic> && data['rideId'] == widget.rideId) {
      setState(() {
        _ride = data;
      });
    }
  }
  
  void _updateMarkers() {
    List<flutter_map.Marker> newMarkers = [];
    
    // Add rider marker (current location)
    if (_riderLocation != null) {
      newMarkers.add(
        flutter_map.Marker(
          point: _riderLocation!,
          child: const Icon(Icons.person_pin, color: Colors.blue, size: 30),
        ),
      );
    } else {
      // Fallback to default location if rider location not available
      newMarkers.add(
        flutter_map.Marker(
          point: const LatLng(36.7213, 3.0376),
          child: const Icon(Icons.person_pin, color: Colors.blue, size: 30),
        ),
      );
    }
    
    // Add driver marker if available
    if (_driverLocation != null) {
      newMarkers.add(
        flutter_map.Marker(
          point: _driverLocation!,
          child: const Icon(Icons.local_taxi, color: Colors.black, size: 30),
        ),
      );
    }
    
    setState(() {
      _markers = newMarkers;
    });
  }
  
  Future<void> _loadRideDetails() async {
    try {
      // Use the new endpoint that includes location data
      final response = await ApiService().getRideWithLocations(widget.rideId);
      if (response['success'] && mounted) {
        setState(() {
          _ride = response['data']['ride'];
          _isLoading = false;
          
          // Update locations if available
          if (_ride != null && _ride!['driverLocation'] != null) {
            _driverLocation = LatLng(
              _ride!['driverLocation']['latitude'],
              _ride!['driverLocation']['longitude']
            );
          }
          
          if (_ride != null && _ride!['riderLocation'] != null) {
            _riderLocation = LatLng(
              _ride!['riderLocation']['latitude'],
              _ride!['riderLocation']['longitude']
            );
          }
          
          _updateMarkers();
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading ride: ${error.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
  
  Future<void> _cancelRide() async {
    try {
      final createdAt = DateTime.parse(_ride!['createdAt']);
      final response = await ApiService().cancelRide(widget.rideId, createdAt);
      if (response['success'] && mounted) {
        setState(() {
          _ride = response['data']['ride'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: response['data']['ride']['cancellationFeeApplied'] 
              ? AppTheme.errorColor 
              : AppTheme.successColor,
          ),
        );
        
        // Navigate back to home after a delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/');
          }
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cancelling ride: ${error.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
  
  Future<void> _completeRide() async {
    try {
      final response = await ApiService().updateRideStatus(widget.rideId, 'completed');
      if (response['success'] && mounted) {
        setState(() {
          _ride = response['data']['ride'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: AppTheme.successColor,
          ),
        );
        
        // Navigate to rating screen after a delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RatingScreen(rideId: widget.rideId),
              ),
            );
          }
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing ride: ${error.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Status'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _ride == null
              ? const Center(child: Text('Failed to load ride details'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Map with route
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: UniversalMapWidget(
                          latitude: 36.7213,
                          longitude: 3.0376,
                          zoom: 13.0,
                          markers: _markers,
                          polylines: [
                            if (_riderLocation != null && _driverLocation != null)
                              flutter_map.Polyline(
                                points: MapConfig.generateCurvedRoute(_riderLocation!, _driverLocation!),
                                color: AppTheme.primaryColor,
                                strokeWidth: 4.0,
                              ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Ride Info
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Ride ID:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(_ride!['id']),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Status:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(_ride!['status']),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      _ride!['status'].toUpperCase(),
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Vehicle:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(_ride!['vehicleType'] ?? 'Not assigned'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Estimated Fare:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('\$${_ride!['finalFare'] ?? _ride!['baseFare']}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Driver Info (if assigned)
                      if (_ride!['driver'] != null) ...[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Driver Information',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 30,
                                      backgroundColor: AppTheme.primaryColor,
                                      child: Icon(Icons.person, color: Colors.white, size: 30),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_ride!['driver']['firstName']} ${_ride!['driver']['lastName']}',
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text('★★★★★ (4.9)'),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        // TODO: Implement call driver
                                      },
                                      icon: const Icon(Icons.phone),
                                      label: const Text('Call'),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                              rideId: _ride!['id'],
                                              driverId: _ride!['driver']['id'],
                                              currentUserId: 'demo-rider', // This should be replaced with actual user ID
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.message),
                                      label: const Text('Message'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                      ],
                      
                      // Cancel Ride Button
                      if (_ride!['status'] == 'requested') ...[
                        ElevatedButton(
                          onPressed: _cancelRide,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.errorColor,
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Text(
                            'Cancel Ride',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                      
                      // Complete Ride Button
                      if (_ride!['status'] == 'in_progress') ...[
                        ElevatedButton(
                          onPressed: _completeRide,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.successColor,
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Text(
                            'Complete Ride',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status) {
      case 'requested':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'in_progress':
        return Colors.green;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return AppTheme.errorColor;
      default:
        return Colors.grey;
    }
  }
}
