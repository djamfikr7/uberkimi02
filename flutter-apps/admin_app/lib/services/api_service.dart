import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:admin_app/models/user_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:admin_app/config/environment.dart';
import 'package:admin_app/config/dev_config.dart';

class ApiService {
  static String _baseUrl = Environment.apiBaseUrl;
  static String _demoBaseUrl = '${Environment.apiBaseUrl}/auth/demo';

  // Use mock data based on environment configuration
  static bool _useMockData = Environment.useMockData || DevConfig.useMockData;

  // Singleton pattern
  ApiService._internal();
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  // Shared preferences for token storage
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'current_user';

  // Get current token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
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
        print('✅ Socket connected: ${_socket?.id}');
      });

      _socket?.on('disconnect', (_) {
        _isSocketConnected = false;
        print('🔴 Socket disconnected');
      });

      _socket?.on('connect_error', (error) {
        _isSocketConnected = false;
        print('❌ Socket connection error: $error');
      });

      // Handle ride status updates
      _socket?.on('ride_status_updated', (data) {
        print('🚗 Ride status update received: $data');
        // TODO: Implement event handling for ride status updates
      });

      // Handle location updates
      _socket?.on('location_updated', (data) {
        print('📍 Location update received: $data');
        // TODO: Implement event handling for location updates
      });
    } catch (e) {
      _isSocketConnected = false;
      print('❌ Socket connection failed: ${e.toString()}');
      rethrow;
    }
  }

  // Disconnect Socket.io
  Future<void> _disconnectSocket() async {
    try {
      if (_socket != null && _isSocketConnected) {
        _socket?.disconnect();
        _socket?.dispose();
        _socket = null;
        _isSocketConnected = false;
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

  // Get dashboard stats
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      if (_useMockData) {
        // Mock response for development
        await Future.delayed(const Duration(seconds: 1));
        return {
          'success': true,
          'message': 'Dashboard stats retrieved successfully',
          'data': {
            'stats': {
              'activeUsers': 1245,
              'activeDrivers': 456,
              'dailyRides': 892,
              'dailyRevenue': 12450.00,
              'averageRating': 4.7,
              'completionRate': 95.5,
              'averageWaitTime': 2.5
            }
          }
        };
      }

      final response = await get('/admin/dashboard');
      return response;
    } catch (e) {
      throw Exception('Failed to get dashboard stats: ${e.toString()}');
    }
  }

  // Get all users
  Future<Map<String, dynamic>> getAllUsers({int page = 1, int limit = 10, String? type}) async {
    try {
      if (_useMockData) {
        // Mock response for development
        await Future.delayed(const Duration(seconds: 1));
        return {
          'success': true,
          'message': 'Users retrieved successfully',
          'data': {
            'users': [
              {
                'id': 'user_1',
                'email': 'user1@example.com',
                'firstName': 'John',
                'lastName': 'Doe',
                'userType': 'rider',
                'phoneNumber': '+1234567890',
                'status': 'active',
                'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String()
              },
              {
                'id': 'user_2',
                'email': 'user2@example.com',
                'firstName': 'Jane',
                'lastName': 'Smith',
                'userType': 'driver',
                'phoneNumber': '+1987654321',
                'status': 'active',
                'createdAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String()
              }
            ],
            'total': 2,
            'page': page,
            'limit': limit,
            'totalPages': 1
          }
        };
      }

      final Map<String, String> params = {
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (type != null) {
        params['type'] = type;
      }

      final response = await get('/admin/users', params: params);
      return response;
    } catch (e) {
      throw Exception('Failed to get users: ${e.toString()}');
    }
  }

  // Get all rides
  Future<Map<String, dynamic>> getAllRides({int page = 1, int limit = 10, String? status}) async {
    try {
      if (_useMockData) {
        // Mock response for development
        await Future.delayed(const Duration(seconds: 1));
        return {
          'success': true,
          'message': 'Rides retrieved successfully',
          'data': {
            'rides': [
              {
                'id': 'ride_1',
                'riderId': 'user_1',
                'driverId': 'driver_1',
                'status': 'completed',
                'pickupLocation': '123 Main St',
                'dropoffLocation': '456 Oak Ave',
                'distanceKm': 5.2,
                'fare': 15.50,
                'vehicleType': 'UberX',
                'paymentMethod': 'cash',
                'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String()
              },
              {
                'id': 'ride_2',
                'riderId': 'user_2',
                'driverId': 'driver_2',
                'status': 'in_progress',
                'pickupLocation': '789 Pine Rd',
                'dropoffLocation': '321 Elm Blvd',
                'distanceKm': 12.8,
                'fare': 28.75,
                'vehicleType': 'Comfort',
                'paymentMethod': 'cash',
                'createdAt': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String()
              }
            ],
            'total': 2,
            'page': page,
            'limit': limit,
            'totalPages': 1
          }
        };
      }

      final Map<String, String> params = {
        'page': page.toString(),
        'limit': limit.toString(),
      };
      
      if (status != null) {
        params['status'] = status;
      }

      final response = await get('/admin/rides', params: params);
      return response;
    } catch (e) {
      throw Exception('Failed to get rides: ${e.toString()}');
    }
  }

  // Get system health
  Future<Map<String, dynamic>> getSystemHealth() async {
    try {
      if (_useMockData) {
        // Mock response for development
        await Future.delayed(const Duration(seconds: 1));
        return {
          'success': true,
          'message': 'System health retrieved successfully',
          'data': {
            'health': {
              'status': 'healthy',
              'timestamp': DateTime.now().toIso8601String(),
              'services': {
                'database': 'connected',
                'cache': 'connected',
                'paymentGateway': 'connected',
                'notificationService': 'connected'
              },
              'metrics': {
                'responseTime': '45ms',
                'errorRate': '0.1%',
                'uptime': '99.9%'
              }
            }
          }
        };
      }

      final response = await get('/admin/health');
      return response;
    } catch (e) {
      throw Exception('Failed to get system health: ${e.toString()}');
    }
  }

  // Update user status
  Future<Map<String, dynamic>> updateUserStatus(String userId, String status) async {
    try {
      if (_useMockData) {
        // Mock response for development
        await Future.delayed(const Duration(seconds: 1));
        return {
          'success': true,
          'message': 'User status updated successfully',
          'data': {
            'user': {
              'id': userId,
              'status': status
            }
          }
        };
      }

      final response = await put('/admin/users/$userId/status', {'status': status});
      return response;
    } catch (e) {
      throw Exception('Failed to update user status: ${e.toString()}');
    }
  }

  // Get user details
  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    try {
      if (_useMockData) {
        // Mock response for development
        await Future.delayed(const Duration(seconds: 1));
        return {
          'success': true,
          'message': 'User details retrieved successfully',
          'data': {
            'user': {
              'id': userId,
              'email': 'user@example.com',
              'firstName': 'John',
              'lastName': 'Doe',
              'userType': 'rider',
              'phoneNumber': '+1234567890',
              'status': 'active',
              'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String()
            }
          }
        };
      }

      final response = await get('/admin/users/$userId');
      return response;
    } catch (e) {
      throw Exception('Failed to get user details: ${e.toString()}');
    }
  }
}