import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:latlong2/latlong.dart';
import 'package:driver_app/theme/app_theme.dart';
import 'package:driver_app/services/api_service.dart';
import 'package:driver_app/utils/location_service.dart';
import 'package:uber_shared/map_widget.dart';
import 'package:driver_app/screens/driver/rating_screen.dart';
import 'dart:async';

class RideNotificationScreen extends StatefulWidget {
  final Map<String, dynamic> rideData;
  
  const RideNotificationScreen({super.key, required this.rideData});

  @override
  State<RideNotificationScreen> createState() => _RideNotificationScreenState();
}

class _RideNotificationScreenState extends State<RideNotificationScreen> {
  bool _isLoading = false;

  Future<void> _acceptRide() async {
    setState(() => _isLoading = true);

    try {
      final rideId = widget.rideData['id'];
      final response = await ApiService().acceptRide(rideId);
      
      if (response['success'] && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ride accepted successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        
        // Navigate to ride tracking screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RideTrackingScreen(rideId: rideId),
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Failed to accept ride'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error accepting ride: ${error.toString()}'),
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

  Future<void> _declineRide() async {
    // For now, just pop the screen
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pickupLocation = widget.rideData['pickupLocation'];
    final dropoffLocation = widget.rideData['dropoffLocation'];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Ride Request'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
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
                latitude: pickupLocation != null ? pickupLocation['lat'] : MapConfig.defaultLatitude,
                longitude: pickupLocation != null ? pickupLocation['lng'] : MapConfig.defaultLongitude,
                zoom: 13.0,
                markers: [
                  if (pickupLocation != null)
                    flutter_map.Marker(
                      point: LatLng(pickupLocation['lat'], pickupLocation['lng']),
                      child: const Icon(Icons.location_on, color: Colors.blue, size: 30),
                    ),
                  if (dropoffLocation != null)
                    flutter_map.Marker(
                      point: LatLng(dropoffLocation['lat'], dropoffLocation['lng']),
                      child: const Icon(Icons.location_on, color: Colors.red, size: 30),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Ride Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ride Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
                    // Pickup Address
                    const Text(
                      'Pickup Location:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.rideData['pickupAddress'] ?? 'Unknown'),
                    const SizedBox(height: 8),
                    
                    // Dropoff Address
                    const Text(
                      'Dropoff Location:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.rideData['dropoffAddress'] ?? 'Unknown'),
                    const SizedBox(height: 8),
                    
                    // Vehicle Type
                    const Text(
                      'Vehicle Type:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.rideData['vehicleType'] ?? 'uber-x'),
                    const SizedBox(height: 8),
                    
                    // Estimated Fare
                    const Text(
                      'Estimated Fare:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('\$${widget.rideData['baseFare'] ?? '0.00'}'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Rider Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rider Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    
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
                            const Text(
                              'John Doe',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            const Text('★★★★★ (4.8)'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _declineRide,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorColor,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Decline',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _acceptRide,
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
                            'Accept Ride',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Ride Tracking Screen for Drivers
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
  bool _isLate = false;
  
  @override
  void initState() {
    super.initState();
    _loadRideDetails();
    _setupLocationTracking();
    _startTimeoutTimer();
  }
  
  @override
  void dispose() {
    // Stop location tracking when screen is disposed
    LocationService.stopLocationTracking();
    ApiService().unregisterLocationListener(_handleLocationUpdate);
    ApiService().unregisterRideStatusListener(_handleRideStatusUpdate);
    _timeoutTimer?.cancel();
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
                content: Text('Rider pickup is taking longer than expected. Please contact support if needed.'),
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
          // Update rider location
          _riderLocation = LatLng(data['latitude'], data['longitude']);
          _updateMarkers();
        }
      });
    } else if (data is Map<String, dynamic> && 
               data.containsKey('latitude') && 
               data.containsKey('longitude') &&
               data.containsKey('userType') &&
               data['userType'] == 'driver') {
      // This is a driver location update
      setState(() {
        _driverLocation = LatLng(data['latitude'], data['longitude']);
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
    
    // Add rider marker if available
    if (_riderLocation != null) {
      newMarkers.add(
        flutter_map.Marker(
          point: _riderLocation!,
          child: const Icon(Icons.person_pin, color: Colors.blue, size: 30),
        ),
      );
    }
    
    // Add driver marker (current location)
    if (_driverLocation != null) {
      newMarkers.add(
        flutter_map.Marker(
          point: _driverLocation!,
          child: const Icon(Icons.local_taxi, color: Colors.black, size: 30),
        ),
      );
    } else {
      // Fallback to default location if driver location not available
      newMarkers.add(
        flutter_map.Marker(
          point: const LatLng(36.7213, 3.0376),
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
      final response = await ApiService().getRide(widget.rideId);
      if (response['success'] && mounted) {
        setState(() {
          _ride = response['data']['ride'];
          _isLoading = false;
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
  
  Future<void> _startRide() async {
    try {
      final response = await ApiService().updateRideStatus(widget.rideId, 'in_progress');
      if (response['success'] && mounted) {
        setState(() {
          _ride = response['data']['ride'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ride started successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting ride: ${error.toString()}'),
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
          const SnackBar(
            content: Text('Ride completed successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        
        // Navigate back to dashboard after a delay
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
            content: Text('Error completing ride: ${error.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
  
  Future<void> _confirmCashPayment() async {
    try {
      // Call API to confirm cash payment
      final response = await ApiService().updatePaymentStatus(widget.rideId, 'completed');
      
      if (response['success'] && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cash payment confirmed successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        
        // Update ride state
        setState(() {
          _ride = response['data']['ride'];
        });
        
        // Navigate to rating screen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RatingScreen(rideId: widget.rideId),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Failed to confirm cash payment'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error confirming cash payment: ${error.toString()}'),
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
        title: const Text('Ride in Progress'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
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
                      
                      // Rider Info
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Rider Information',
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
                                      const Text(
                                        'John Doe',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text('★★★★★ (4.8)'),
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
                                      // TODO: Implement call rider
                                    },
                                    icon: const Icon(Icons.phone),
                                    label: const Text('Call'),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      // TODO: Implement message rider
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
                      
                      // Action Buttons based on status
                      if (_ride!['status'] == 'accepted') ...[
                        ElevatedButton(
                          onPressed: _startRide,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Text(
                            'Start Ride',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ] else if (_ride!['status'] == 'in_progress') ...[
                        ElevatedButton(
                          onPressed: _completeRide,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.successColor,
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Text(
                            'Complete Ride',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ] else if (_ride!['status'] == 'completed') ...[
                        ElevatedButton(
                          onPressed: _confirmCashPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Text(
                            'Confirm Cash Payment',
                            style: TextStyle(color: Colors.white, fontSize: 16),
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