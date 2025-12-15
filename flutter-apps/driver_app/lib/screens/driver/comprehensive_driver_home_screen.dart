import 'package:flutter/material.dart';
import 'package:uber_shared/uber_shared.dart';
import 'package:driver_app/screens/driver/available_rides_screen.dart';
import 'package:driver_app/screens/driver/driver_home_screen.dart' as driver_home;

class ComprehensiveDriverHomeScreen extends StatefulWidget {
  const ComprehensiveDriverHomeScreen({super.key});

  @override
  State<ComprehensiveDriverHomeScreen> createState() => _ComprehensiveDriverHomeScreenState();
}

class _ComprehensiveDriverHomeScreenState extends State<ComprehensiveDriverHomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  bool _isOnline = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeomorphicAppBar(
        title: const Text('Driver Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications coming soon'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings coming soon'),
                ),
              );
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
          const AvailableRidesScreen(),
          const driver_home.EarningsTab(),
          const driver_home.ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        selectedItemColor: AppTheme.primaryLight,
        unselectedItemColor: AppTheme.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_taxi_outlined),
            activeIcon: Icon(Icons.local_taxi),
            label: 'Rides',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _toggleOnlineStatus(bool value) {
    setState(() {
      _isOnline = value;
    });
    
    // Show status change message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isOnline ? 'You are now online' : 'You are now offline'),
          backgroundColor: _isOnline ? AppTheme.success : AppTheme.error,
        ),
      );
    }
  }
}

// Enhanced Dashboard Tab with neomorphic design
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
          // Online Status Card
          NeomorphicCard(
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
                    Text(
                      isOnline ? 'You are currently online' : 'You are currently offline',
                      style: TextStyle(
                        color: isOnline ? AppTheme.success : AppTheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    NeomorphicToggleSwitch(
                      value: isOnline,
                      onChanged: onToggleOnline,
                      activeText: 'ON',
                      inactiveText: 'OFF',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Go online to start receiving ride requests',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Quick Stats
          Text(
            'Today\'s Summary',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: NeomorphicCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          '0',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryLight),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rides',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NeomorphicCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          '\$0.00',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.accentStart),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Earnings',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NeomorphicCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          '4.9',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.success),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rating',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Vehicle Information
          Text(
            'Vehicle Information',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          
          NeomorphicCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Toyota Camry 2020',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('License Plate: ABC123'),
                  const SizedBox(height: 4),
                  const Text('Color: White'),
                  const SizedBox(height: 12),
                  NeomorphicButton(
                    onPressed: () {
                      // TODO: Edit vehicle information
                    },
                    child: const Text('Edit Vehicle Info'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Recent Activity
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          
          NeomorphicCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.history, size: 40, color: AppTheme.textSecondary),
                  const SizedBox(height: 12),
                  const Text(
                    'No recent activity',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Complete rides to see your activity here',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}