import 'package:flutter_test/flutter_test.dart';
import 'package:admin_app/services/api_service.dart';

void main() {
  group('Admin App API Service Tests', () {
    late ApiService apiService;

    setUp(() {
      apiService = ApiService();
    });

    test('Dashboard stats should return mock data', () async {
      final result = await apiService.getDashboardStats();
      
      expect(result['success'], true);
      expect(result['data'], isNotNull);
      expect(result['data']['stats'], isNotNull);
      
      final stats = result['data']['stats'];
      expect(stats['activeUsers'], 1245);
      expect(stats['activeDrivers'], 456);
      expect(stats['dailyRides'], 892);
      expect(stats['dailyRevenue'], 12450.00);
      expect(stats['averageRating'], 4.7);
      expect(stats['completionRate'], 95.5);
      expect(stats['averageWaitTime'], 2.5);
    });

    test('Get all users should return mock data', () async {
      final result = await apiService.getAllUsers();
      
      expect(result['success'], true);
      expect(result['data'], isNotNull);
      expect(result['data']['users'], isNotNull);
      expect(result['data']['users'].length, 2);
      
      final users = result['data']['users'];
      expect(users[0]['id'], 'user_1');
      expect(users[0]['userType'], 'rider');
      expect(users[1]['id'], 'user_2');
      expect(users[1]['userType'], 'driver');
    });

    test('Get all users with type filter should work', () async {
      final result = await apiService.getAllUsers(type: 'rider');
      
      expect(result['success'], true);
      expect(result['data'], isNotNull);
    });

    test('Get all rides should return mock data', () async {
      final result = await apiService.getAllRides();
      
      expect(result['success'], true);
      expect(result['data'], isNotNull);
      expect(result['data']['rides'], isNotNull);
      expect(result['data']['rides'].length, 2);
      
      final rides = result['data']['rides'];
      expect(rides[0]['id'], 'ride_1');
      expect(rides[0]['status'], 'completed');
      expect(rides[1]['id'], 'ride_2');
      expect(rides[1]['status'], 'in_progress');
    });

    test('Get all rides with status filter should work', () async {
      final result = await apiService.getAllRides(status: 'completed');
      
      expect(result['success'], true);
      expect(result['data'], isNotNull);
    });

    test('Get system health should return mock data', () async {
      final result = await apiService.getSystemHealth();
      
      expect(result['success'], true);
      expect(result['data'], isNotNull);
      expect(result['data']['health'], isNotNull);
      
      final health = result['data']['health'];
      expect(health['status'], 'healthy');
      expect(health['services'], isNotNull);
      expect(health['metrics'], isNotNull);
      
      final services = health['services'];
      expect(services['database'], 'connected');
      expect(services['cache'], 'connected');
      expect(services['paymentGateway'], 'connected');
      expect(services['notificationService'], 'connected');
    });

    test('Update user status should return mock data', () async {
      final result = await apiService.updateUserStatus('user_1', 'suspended');
      
      expect(result['success'], true);
      expect(result['data'], isNotNull);
      expect(result['data']['user'], isNotNull);
      expect(result['data']['user']['id'], 'user_1');
      expect(result['data']['user']['status'], 'suspended');
    });

    test('Get user details should return mock data', () async {
      final result = await apiService.getUserDetails('user_1');
      
      expect(result['success'], true);
      expect(result['data'], isNotNull);
      expect(result['data']['user'], isNotNull);
      expect(result['data']['user']['id'], 'user_1');
      expect(result['data']['user']['userType'], 'rider');
    });
  });
}