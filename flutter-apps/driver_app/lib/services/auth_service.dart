import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uber_shared/uber_shared.dart';
import '../config/environment.dart';
import '../models/user_model.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService() : _apiClient = ApiClient(baseUrl: Environment.apiBaseUrl);

  /// Perform demo login for development
  Future<Map<String, dynamic>> demoLogin() async {
    try {
      final response = await _apiClient.post('/auth/demo/login/driver');
      
      if (_apiClient.isSuccess(response)) {
        final data = _apiClient.parseJson(response);
        if (data['success'] == true) {
          // Create UserModel from the response data
          final user = UserModel(
            id: data['user']['id'],
            email: data['user']['email'],
            firstName: data['user']['firstName'],
            lastName: data['user']['lastName'],
            userType: data['user']['role'],
            phoneNumber: data['user']['phoneNumber'] ?? '',
            profilePictureUrl: '',
            token: data['token'],
          );
          
          return {
            'success': true,
            'token': data['token'],
            'user': user,
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Demo login failed',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'HTTP ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  /// Register a new driver
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/register',
        body: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': phoneNumber,
        },
      );
      
      if (_apiClient.isSuccess(response)) {
        final data = _apiClient.parseJson(response);
        if (data['success'] == true) {
          // Create UserModel from the response data
          final user = UserModel(
            id: data['user']['id'],
            email: data['user']['email'],
            firstName: data['user']['firstName'],
            lastName: data['user']['lastName'],
            userType: data['user']['role'],
            phoneNumber: data['user']['phoneNumber'] ?? '',
            profilePictureUrl: '',
          );
          
          return {
            'success': true,
            'message': data['message'],
            'user': user,
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Registration failed',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'HTTP ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  /// Login as a driver
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
        },
      );
      
      if (_apiClient.isSuccess(response)) {
        final data = _apiClient.parseJson(response);
        if (data['success'] == true) {
          // Create UserModel from the response data
          final user = UserModel(
            id: data['user']['id'],
            email: data['user']['email'],
            firstName: data['user']['firstName'],
            lastName: data['user']['lastName'],
            userType: data['user']['role'],
            phoneNumber: data['user']['phoneNumber'] ?? '',
            profilePictureUrl: '',
            token: data['token'],
          );
          
          return {
            'success': true,
            'token': data['token'],
            'user': user,
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Login failed',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'HTTP ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }
}