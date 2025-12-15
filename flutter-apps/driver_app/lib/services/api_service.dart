import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:async'; // Add this import for Timer
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:driver_app/models/user_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:driver_app/config/environment.dart';

class ApiService {
  static String _baseUrl = Environment.apiBaseUrl;
  static String _demoBaseUrl = '${Environment.apiBaseUrl}/auth/demo';

  // Use mock data based on environment configuration
  static bool _useMockData = Environment.useMockData;

  // Singleton pattern
  ApiService._internal();
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  // Shared preferences for token storage
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'current_user';

  // Location update listeners
  static List<Function(Map<String, dynamic>)> _locationUpdateListeners = [];
  static List<Function(Map<String, dynamic>)> _rideStatusUpdateListeners = [];
  static Timer? _locationPollingTimer;

  // Get current token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Public method to get token
  Future<String?> getToken() async {
    return await _getToken();
  }

  // Set token
  Future<void> _setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Remove token
  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // Set current user
  Future<void> _setCurrentUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // Get current user
  Future<UserModel?> _getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // Remove current user
  Future<void> _removeCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // Clear all auth data
  Future<void> clearAuthData() async {
    await _removeToken();
    await _removeCurrentUser();
    await _disconnectSocket();
  }

  // Socket.io connection
  static IO.Socket? _socket;
  static bool _isSocketConnected = false;
  static int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const int _reconnectDelay = 5000; // 5 seconds
  static Timer? _reconnectTimer;
  
  // Event listeners
  static List<Function(dynamic)> _rideStatusListeners = [];
  static List<Function(dynamic)> _locationListeners = [];
  static List<Function(dynamic)> _newRideRequestListeners = [];

  // Connect to Socket.io
  Future<void> connectSocket(String token) async {
    try {
      if (_isSocketConnected) {
        print('ℹ️ Socket already connected');
        return;
      }

      print('🔌 Connecting to Socket.io server...');

      _socket = IO.io(Environment.socketBaseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
        'extraHeaders': {'Authorization': 'Bearer $token'},
      });

      _socket?.on('connect', (_) {
        _isSocketConnected = true;
        _resetReconnectAttempts();
        print('✅ Socket connected: ${_socket?.id}');
      });

      _socket?.on('disconnect', (_) {
        _isSocketConnected = false;
        print('🔴 Socket disconnected');
        _attemptReconnect(token);
      });

      _socket?.on('connect_error', (error) {
        _isSocketConnected = false;
        print('❌ Socket connection error: $error');
        _attemptReconnect(token);
      });

      // Handle ride status updates
      _socket?.on('ride_status_updated', (data) {
        print('🚗 Ride status update received: $data');
        // Notify listeners about ride status updates
        if (_rideStatusListeners.isNotEmpty) {
          for (var listener in _rideStatusListeners) {
            listener(data);
          }
        }
      });

      // Handle location updates
      _socket?.on('location_updated', (data) {
        print('📍 Location update received: $data');
        // Notify listeners about location updates
        if (_locationListeners.isNotEmpty) {
          for (var listener in _locationListeners) {
            listener(data);
          }
        }
      });
      
      // Handle new ride requests
      _socket?.on('new_ride_request', (data) {
        print('🔔 New ride request received: $data');
        // Notify listeners about new ride requests
        if (_newRideRequestListeners.isNotEmpty) {
          for (var listener in _newRideRequestListeners) {
            listener(data);
          }
        }
      });
    } catch (e) {
      _isSocketConnected = false;
      print('❌ Socket connection failed: ${e.toString()}');
      rethrow;
    }
  }
  
  // Attempt to reconnect
  static void _attemptReconnect(String token) {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      print('❌ Maximum reconnection attempts reached');
      return;
    }
    
    _reconnectAttempts++;
    print('🔁 Attempting to reconnect ($_reconnectAttempts/$_maxReconnectAttempts) in ${_reconnectDelay}ms');
    
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(milliseconds: _reconnectDelay), () {
      _instance.connectSocket(token);
    });
  }
  
  // Reset reconnection attempts
  static void _resetReconnectAttempts() {
    _reconnectAttempts = 0;
    _reconnectTimer?.cancel();
  }

  // Disconnect Socket.io
  Future<void> _disconnectSocket() async {
    try {
      if (_socket != null && _isSocketConnected) {
        _socket?.disconnect();
        _socket?.dispose();
        _socket = null;
        _isSocketConnected = false;
        _resetReconnectAttempts();
        print('🔌 Socket disconnected');
      }
    } catch (e) {
      print('❌ Error disconnecting socket: ${e.toString()}');
    }
  }

  // Emit ride status update
  Future<void> emitRideStatusUpdate(Map<String, dynamic> data) async {
    if (!_isSocketConnected) {
      throw Exception('Socket not connected');
    }

    try {
      _socket?.emit('ride_status_update', data);
      print('🚗 Ride status update emitted: $data');
    } catch (e) {
      print('❌ Error emitting ride status update: ${e.toString()}');
      rethrow;
    }
  }

  // Emit location update
  Future<void> emitLocationUpdate(Map<String, dynamic> data) async {
    if (!_isSocketConnected) {
      throw Exception('Socket not connected');
    }

    try {
      _socket?.emit('location_update', data);
      print('📍 Location update emitted: $data');
    } catch (e) {
      print('❌ Error emitting location update: ${e.toString()}');
      rethrow;
    }
  }

  // Check if socket is connected
  bool isSocketConnected() {
    return _isSocketConnected;
  }
  
  // Register ride status listener
  void registerRideStatusListener(Function(dynamic) listener) {
    _rideStatusListeners.add(listener);
  }
  
  // Unregister ride status listener
  void unregisterRideStatusListener(Function(dynamic) listener) {
    _rideStatusListeners.remove(listener);
  }
  
  // Register location listener
  void registerLocationListener(Function(dynamic) listener) {
    _locationListeners.add(listener);
  }
  
  // Unregister location listener
  void unregisterLocationListener(Function(dynamic) listener) {
    _locationListeners.remove(listener);
  }
  
  // Clear all listeners
  void clearAllListeners() {
    _rideStatusListeners.clear();
    _locationListeners.clear();
  }
  
  // Register new ride request listener
  void registerNewRideRequestListener(Function(dynamic) listener) {
    _newRideRequestListeners.add(listener);
  }
  
  // Unregister new ride request listener
  void unregisterNewRideRequestListener(Function(dynamic) listener) {
    _newRideRequestListeners.remove(listener);
  }
  
  // Clear all new ride request listeners
  void clearNewRideRequestListeners() {
    _newRideRequestListeners.clear();
  }

  // Demo login methods (bypass OTP as requested)
  Future<UserModel> demoLoginRider() async {
    if (_useMockData) {
      // Return mock data for demo purposes
      final user = UserModel(
        id: 'rider_123',
        email: 'rider@demo.com',
        firstName: 'Demo',
        lastName: 'Rider',
        userType: 'rider',
        phoneNumber: '+1234567890',
        profilePictureUrl: 'https://randomuser.me/api/portraits/men/1.jpg',
        token: 'demo_rider_token',
      );
      await _setToken('demo_rider_token');
      await _setCurrentUser(user);
      // Connect socket for real-time updates
      if (!Environment.useMockData) {
        await connectSocket('demo_rider_token');
      }
      return user;
    }

    try {
      final response = await http.post(
        Uri.parse('$_demoBaseUrl/login/rider'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['data']['user'];
        final token = data['data']['token'];

        final user = UserModel.fromJson(userData);
        await _setToken(token);
        await _setCurrentUser(user);

        return user;
      } else {
        throw Exception('Demo login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Demo login error: ${e.toString()}');
    }
  }

  Future<UserModel> demoLoginDriver() async {
    if (_useMockData) {
      // Return mock data for demo purposes
      final user = UserModel(
        id: 'driver_123',
        email: 'driver@demo.com',
        firstName: 'Demo',
        lastName: 'Driver',
        userType: 'driver',
        phoneNumber: '+1234567890',
        profilePictureUrl: 'https://randomuser.me/api/portraits/men/2.jpg',
        token: 'demo_driver_token',
      );
      await _setToken('demo_driver_token');
      await _setCurrentUser(user);
      // Connect socket for real-time updates
      if (!Environment.useMockData) {
        await connectSocket('demo_driver_token');
      }
      return user;
    }

    try {
      final response = await http.post(
        Uri.parse('$_demoBaseUrl/login/driver'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['data']['user'];
        final token = data['data']['token'];

        final user = UserModel.fromJson(userData);
        await _setToken(token);
        await _setCurrentUser(user);

        return user;
      } else {
        throw Exception('Demo login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Demo login error: ${e.toString()}');
    }
  }

  Future<UserModel> demoLoginAdmin() async {
    if (_useMockData) {
      // Return mock data for demo purposes
      final user = UserModel(
        id: 'admin_123',
        email: 'admin@demo.com',
        firstName: 'Demo',
        lastName: 'Admin',
        userType: 'admin',
        phoneNumber: '+1234567890',
        profilePictureUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
        token: 'demo_admin_token',
      );
      await _setToken('demo_admin_token');
      await _setCurrentUser(user);
      // Connect socket for real-time updates
      if (!Environment.useMockData) {
        await connectSocket('demo_admin_token');
      }
      return user;
    }

    try {
      final response = await http.post(
        Uri.parse('$_demoBaseUrl/login/admin'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['data']['user'];
        final token = data['data']['token'];

        final user = UserModel.fromJson(userData);
        await _setToken(token);
        await _setCurrentUser(user);

        return user;
      } else {
        throw Exception('Demo login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Demo login error: ${e.toString()}');
    }
  }

  // Regular login
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['data']['user'];
        final token = data['data']['token'];

        final user = UserModel.fromJson(userData);
        await _setToken(token);
        await _setCurrentUser(user);
        // Connect socket for real-time updates
        if (!Environment.useMockData) {
          await connectSocket(token);
        }

        return user;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Login error: ${e.toString()}');
    }
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$_baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['data']['user'];
        return UserModel.fromJson(userData);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.get(
        Uri.parse('$_baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await clearAuthData();
  }

  // Health check
  Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/health'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Health check failed');
      }
    } catch (e) {
      throw Exception('Health check error: ${e.toString()}');
    }
  }

  // Generic GET request with auth
  Future<dynamic> get(String endpoint, {Map<String, String>? params}) async {
    try {
      final token = await _getToken();
      final uri = Uri.parse(
        '$_baseUrl$endpoint',
      ).replace(queryParameters: params);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('GET request error: ${e.toString()}');
    }
  }

  // Generic POST request with auth
  Future<dynamic> post(String endpoint, dynamic data) async {
    try {
      final token = await _getToken();

      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('POST request error: ${e.toString()}');
    }
  }

  // Generic PUT request with auth
  Future<dynamic> put(String endpoint, dynamic data) async {
    try {
      final token = await _getToken();

      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('PUT request error: ${e.toString()}');
    }
  }

  // Generic DELETE request with auth
  Future<dynamic> delete(String endpoint) async {
    try {
      final token = await _getToken();

      final response = await http.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      return _handleResponse(response);
    } catch (e) {
      throw Exception('DELETE request error: ${e.toString()}');
    }
  }

  // Accept a ride
  Future<Map<String, dynamic>> acceptRide(String rideId) async {
    try {
      if (_useMockData) {
        // Mock response for development
        await Future.delayed(const Duration(seconds: 1));
        return {
          'success': true,
          'message': 'Ride accepted successfully',
          'data': {
            'ride': {
              'id': rideId,
              'status': 'accepted',
              'driverId': 'mock-driver-id',
              'acceptedAt': DateTime.now().toIso8601String(),
            }
          }
        };
      }

      final response = await put('/rides/$rideId/accept', {});
      return response;
    } catch (e) {
      throw Exception('Failed to accept ride: ${e.toString()}');
    }
  }

  // Get ride by ID
  Future<Map<String, dynamic>> getRide(String rideId) async {
    try {
      if (_useMockData) {
        // Mock response for development
        await Future.delayed(const Duration(seconds: 1));
        return {
          'success': true,
          'message': 'Ride retrieved successfully',
          'data': {
            'ride': {
              'id': rideId,
              'status': 'accepted',
              'pickupLocation': {'lat': 36.7213, 'lng': 3.0376},
              'dropoffLocation': {'lat': 36.75, 'lng': 3.05},
              'pickupAddress': 'Current Location',
              'dropoffAddress': 'Destination',
              'vehicleType': 'uber-x',
              'baseFare': 15.0,
              'finalFare': 15.0,
              'createdAt': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
            }
          }
        };
      }

      final response = await get('/rides/$rideId');
      return response;
    } catch (e) {
      throw Exception('Failed to get ride: ${e.toString()}');
    }
  }

  // Get ride with location updates
  Future<Map<String, dynamic>> getRideWithLocations(String rideId) async {
    try {
      if (_useMockData) {
        // Mock response for development
        await Future.delayed(const Duration(seconds: 1));
        return {
          'success': true,
          'message': 'Ride retrieved successfully',
          'data': {
            'ride': {
              'id': rideId,
              'status': 'in_progress',
              'pickupLocation': {'lat': 36.7213, 'lng': 3.0376},
              'dropoffLocation': {'lat': 36.75, 'lng': 3.05},
              'pickupAddress': 'Current Location',
              'dropoffAddress': 'Destination',
              'vehicleType': 'uber-x',
              'baseFare': 15.0,
              'finalFare': 15.0,
              'driverLocation': {
                'latitude': 36.73, 
                'longitude': 3.04,
                'timestamp': DateTime.now().toIso8601String(),
              },
              'riderLocation': {
                'latitude': 36.7213, 
                'longitude': 3.0376,
                'timestamp': DateTime.now().toIso8601String(),
              },
              'createdAt': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
            }
          }
        };
      }

      final response = await get('/rides/$rideId/locations');
      return response;
    } catch (e) {
      throw Exception('Failed to get ride with locations: ${e.toString()}');
    }
  }

  // Get available rides for driver
  Future<Map<String, dynamic>> getAvailableRides() async {
    try {
      if (_useMockData) {
        // Mock response for development
        await Future.delayed(const Duration(seconds: 1));
        return {
          'success': true,
          'message': 'Available rides retrieved successfully',
          'data': {
            'rides': [
              {
                'id': 'mock-ride-1',
                'riderId': 'mock-rider-1',
                'riderName': 'John Doe',
                'riderPhoneNumber': '+1234567890',
                'pickupAddress': '123 Main St',
                'dropoffAddress': '456 Oak Ave',
                'pickupLatitude': 40.7128,
                'pickupLongitude': -74.0060,
                'dropoffLatitude': 40.7589,
                'dropoffLongitude': -73.9851,
                'estimatedFare': 15.50,
                'estimatedDistance': 5.2,
                'estimatedDuration': 15,
                'status': 'requested',
                'requestedAt': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
              },
              {
                'id': 'mock-ride-2',
                'riderId': 'mock-rider-2',
                'riderName': 'Jane Smith',
                'riderPhoneNumber': '+0987654321',
                'pickupAddress': '789 Pine St',
                'dropoffAddress': '321 Elm St',
                'pickupLatitude': 40.7589,
                'pickupLongitude': -73.9851,
                'dropoffLatitude': 40.7128,
                'dropoffLongitude': -74.0060,
                'estimatedFare': 12.75,
                'estimatedDistance': 4.1,
                'estimatedDuration': 12,
                'status': 'requested',
                'requestedAt': DateTime.now().toIso8601String(),
              }
            ]
          }
        };
      }

      final response = await get('/rides/available');
      return response;
    } catch (e) {
      throw Exception('Failed to get available rides: ${e.toString()}');
    }
  }

  // Update ride status
  Future<Map<String, dynamic>> updateRideStatus(String rideId, String status) async {
    try {
      if (_useMockData) {
        // Mock response for development
        await Future.delayed(const Duration(seconds: 1));
        return {
          'success': true,
          'message': 'Ride status updated successfully',
          'data': {
            'ride': {
              'id': rideId,
              'status': status,
              'updatedAt': DateTime.now().toIso8601String(),
            }
          }
        };
      }

      final response = await put('/rides/$rideId/status', {'status': status});
      return response;
    } catch (e) {
      throw Exception('Failed to update ride status: ${e.toString()}');
    }
  }
  
  // Cancel ride
  Future<Map<String, dynamic>> cancelRide(String rideId, DateTime rideCreatedAt) async {
    try {
      // Check cancellation policy
      final now = DateTime.now();
      final difference = now.difference(rideCreatedAt);
      
      // If more than 10 minutes have passed, apply fee
      if (difference.inMinutes > 10) {
        // In a real implementation, this would notify the backend about the fee
        print('Cancellation fee would apply for this ride');
      }
      
      if (_useMockData) {
        // Mock response for development
        await Future.delayed(const Duration(seconds: 1));
        return {
          'success': true,
          'message': difference.inMinutes > 10 
            ? 'Ride cancelled with fee applied' 
            : 'Ride cancelled successfully',
          'data': {
            'ride': {
              'id': rideId,
              'status': 'cancelled',
              'cancelledAt': DateTime.now().toIso8601String(),
              'cancellationFeeApplied': difference.inMinutes > 10,
            }
          }
        };
      }

      final response = await put('/rides/$rideId/cancel', {});
      return response;
    } catch (e) {
      throw Exception('Failed to cancel ride: ${e.toString()}');
    }
  }

  // Update ride payment status
  Future<Map<String, dynamic>> updatePaymentStatus(String rideId, String paymentStatus) async {
    try {
      if (_useMockData) {
        // Mock response for development
        await Future.delayed(const Duration(seconds: 1));
        return {
          'success': true,
          'message': 'Ride payment status updated successfully',
          'data': {
            'ride': {
              'id': rideId,
              'paymentStatus': paymentStatus,
              'updatedAt': DateTime.now().toIso8601String(),
            }
          }
        };
      }

      final response = await put('/rides/$rideId/payment-status', {'paymentStatus': paymentStatus});
      return response;
    } catch (e) {
      throw Exception('Failed to update ride payment status: ${e.toString()}');
    }
  }

  // Submit ride rating and feedback
  Future<Map<String, dynamic>> submitRating(String rideId, int rating, {String? feedback}) async {
    try {
      if (_useMockData) {
        // Mock response for development
        await Future.delayed(const Duration(seconds: 1));
        return {
          'success': true,
          'message': 'Rating submitted successfully',
          'data': {
            'ride': {
              'id': rideId,
              'rideRatingDriver': rating,
              'driverFeedback': feedback,
              'updatedAt': DateTime.now().toIso8601String(),
            }
          }
        };
      }

      final Map<String, dynamic> requestData = {
        'rating': rating,
      };
      
      if (feedback != null) {
        requestData['feedback'] = feedback;
      }

      final response = await post('/rides/$rideId/rate', requestData);
      return response;
    } catch (e) {
      throw Exception('Failed to submit rating: ${e.toString()}');
    }
  }

  // Update driver location
  Future<Map<String, dynamic>> updateLocation({
    required double latitude,
    required double longitude,
    required String rideId,
  }) async {
    try {
      if (_useMockData) {
        // Mock response for development
        await Future.delayed(const Duration(milliseconds: 100));
        return {
          'success': true,
          'message': 'Location updated successfully',
        };
      }

      final response = await post('/location/update', {
        'latitude': latitude,
        'longitude': longitude,
        'rideId': rideId,
      });
      return response;
    } catch (e) {
      throw Exception('Failed to update location: ${e.toString()}');
    }
  }

  // Handle API responses
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    if (statusCode >= 200 && statusCode < 300) {
      try {
        return jsonDecode(body);
      } catch (e) {
        return body;
      }
    } else {
      try {
        final errorData = jsonDecode(body);
        throw Exception(
          errorData['message'] ?? 'Request failed with status $statusCode',
        );
      } catch (e) {
        throw Exception('Request failed with status $statusCode');
      }
    }
  }
  
  // Retry mechanism for API calls
  Future<T> _retryApiCall<T>(Future<T> Function() apiCall, {int maxRetries = 3}) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        return await apiCall();
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          throw e;
        }
        // Wait before retrying (exponential backoff)
        await Future.delayed(Duration(milliseconds: 1000 * attempts));
      }
    }
    throw Exception('Max retries exceeded');
  }
  
  // Check network connectivity
  Future<bool> _isNetworkAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
  
  // Register for location updates (static version)
  static void registerStaticLocationListener(Function(Map<String, dynamic>) listener) {
    _locationUpdateListeners.add(listener);
  }

  // Unregister from location updates (static version)
  static void unregisterStaticLocationListener(Function(Map<String, dynamic>) listener) {
    _locationUpdateListeners.remove(listener);
  }

  // Register for ride status updates (static version)
  static void registerStaticRideStatusListener(Function(Map<String, dynamic>) listener) {
    _rideStatusUpdateListeners.add(listener);
  }

  // Unregister from ride status updates (static version)
  static void unregisterStaticRideStatusListener(Function(Map<String, dynamic>) listener) {
    _rideStatusUpdateListeners.remove(listener);
  }

  // Start polling for location updates (simulate real-time updates)
  static void startLocationPolling(String rideId) {
    // Cancel any existing polling
    _locationPollingTimer?.cancel();
    
    // Start polling every 10 seconds
    _locationPollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        // Fetch updated ride details with locations
        final response = await ApiService().getRideWithLocations(rideId);
        if (response['success']) {
          final rideData = response['data']['ride'];
          
          // Notify location listeners
          for (var listener in _locationUpdateListeners) {
            listener(rideData);
          }
          
          // Notify ride status listeners
          for (var listener in _rideStatusUpdateListeners) {
            listener(rideData);
          }
        }
      } catch (error) {
        print('Error polling for location updates: $error');
      }
    });
  }

  // Stop polling for location updates
  static void stopLocationPolling() {
    _locationPollingTimer?.cancel();
    _locationPollingTimer = null;
  }
}
