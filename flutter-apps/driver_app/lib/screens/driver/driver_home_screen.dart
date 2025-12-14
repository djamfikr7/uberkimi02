import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:driver_app/theme/app_theme.dart';
import 'package:driver_app/models/user_model.dart';
import 'package:driver_app/services/api_service.dart';
import 'package:driver_app/screens/driver/ride_notification_screen.dart';
import 'package:uber_shared/map_widget.dart';
import 'dart:async';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  UserModel? _currentUser;
  bool _isOnline = false;
  Timer? _locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _setupRideRequestListener();
    _setupLocationUpdates();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await ApiService().getCurrentUser();
      if (mounted) {
        setState(() => _currentUser = user);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading user: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _setupRideRequestListener() {
    // Register for new ride request notifications
    ApiService().registerNewRideRequestListener(_handleNewRideRequest);
  }

  void _setupLocationUpdates() {
    // Send periodic location updates when online
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isOnline) {
        _sendLocationUpdate();
      }
    });
  }

  void _sendLocationUpdate() async {
    try {
      // In a real implementation, this would get the actual device location
      // For now, we'll use a placeholder location
      final locationData = {
        'latitude': MapConfig.defaultLatitude,
        'longitude': MapConfig.defaultLongitude,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      await ApiService().emitLocationUpdate(locationData);
    } catch (e) {
      print('Error sending location update: $e');
    }
  }

  void _handleNewRideRequest(dynamic data) {
    if (mounted) {
      // Show notification and navigate to ride notification screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('New ride request received!'),
          backgroundColor: AppTheme.primaryColor,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate to ride notification screen
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RideNotificationScreen(rideData: data),
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    // Unregister listeners
    ApiService().unregisterNewRideRequestListener(_handleNewRideRequest);
    _locationUpdateTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    await ApiService().logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _toggleOnlineStatus(bool value) async {
    setState(() {
      _isOnline = value;
    });
    
    // In a real implementation, this would call an API to update driver status
    // For now, we'll just show a message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isOnline ? 'You are now online' : 'You are now offline'),
          backgroundColor: _isOnline ? AppTheme.successColor : AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uber Clone Driver'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications feature coming soon'),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _handleLogout();
              } else if (value == 'profile') {
                // Navigate to profile
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile feature coming soon'),
                  ),
                );
              } else if (value == 'earnings') {
                // Navigate to earnings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Earnings feature coming soon'),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'profile',
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'earnings',
                  child: ListTile(
                    leading: Icon(Icons.account_balance_wallet),
                    title: Text('Earnings'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: [
          DashboardTab(isOnline: _isOnline, onToggleOnline: _toggleOnlineStatus),
          const RidesTab(),
          const EarningsTab(),
          const ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Rides',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Dashboard Tab
class DashboardTab extends StatelessWidget {
  final bool isOnline;
  final Function(bool) onToggleOnline;
  
  const DashboardTab({super.key, required this.isOnline, required this.onToggleOnline});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Online Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(isOnline ? 'You are currently online' : 'You are currently offline'),
                      Switch(
                        value: isOnline,
                        onChanged: onToggleOnline,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Go online to start receiving ride requests',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Map Preview
          const Text(
            'Current Location',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: UniversalMapWidget(
              markers: [
                Marker(
                  point: LatLng(MapConfig.defaultLatitude, MapConfig.defaultLongitude),
                  child: const Icon(Icons.location_pin, color: Colors.blue, size: 40),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Quick Stats
          const Text(
            'Today\'s Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Rides', '0'),
                  _buildStatItem('Earnings', '\$0.00'),
                  _buildStatItem('Rating', '0.0'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Recent Activity
          const Text(
            'Recent Activity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('No recent activity'),
                  const SizedBox(height: 8),
                  Text(
                    'Complete rides to see your activity here',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

// Rides Tab
class RidesTab extends StatelessWidget {
  const RidesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Ride History\n\nView your past rides and trip details here.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// Earnings Tab
class EarningsTab extends StatelessWidget {
  const EarningsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Earnings Dashboard\n\nTrack your daily, weekly, and monthly earnings here.\n\nView payment history and withdrawal options.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// Profile Tab
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Driver Profile\n\nManage your driver profile, vehicle information, and account settings here.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}