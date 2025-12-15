import 'package:flutter/material.dart';
import 'package:uber_shared/widgets/neomorphic_app_bar.dart';
import 'package:uber_shared/widgets/neomorphic_card.dart';
import 'package:uber_shared/widgets/neomorphic_button.dart';
import 'package:admin_app/theme/app_theme.dart';
import 'package:admin_app/services/api_service.dart';
import 'package:admin_app/screens/users_management_screen.dart';
import 'package:admin_app/screens/rides_management_screen.dart';
import 'package:admin_app/screens/system_health_screen.dart';
import 'package:admin_app/screens/analytics_screen.dart';
import 'package:admin_app/screens/dispute_resolution_screen.dart';
import 'package:admin_app/screens/configuration_screen.dart';

// Add the import for the real-time monitoring screen
import 'package:admin_app/screens/realtime_monitoring_screen.dart';

class ComprehensiveAdminDashboardScreen extends StatefulWidget {
  const ComprehensiveAdminDashboardScreen({super.key});

  @override
  State<ComprehensiveAdminDashboardScreen> createState() =>
      _ComprehensiveAdminDashboardScreenState();
}

class _ComprehensiveAdminDashboardScreenState
    extends State<ComprehensiveAdminDashboardScreen> {
  Map<String, dynamic>? _dashboardStats;
  List<dynamic> _recentActivities = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Load dashboard stats
      final statsResponse = await ApiService().getDashboardStats();
      
      // Load recent activities
      final activitiesResponse = await ApiService().getRecentActivities();
      
      if (statsResponse['success'] && activitiesResponse['success'] && mounted) {
        setState(() {
          _dashboardStats = statsResponse['data']['stats'];
          _recentActivities = List<dynamic>.from(activitiesResponse['data']['activities']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = statsResponse['message'] ?? activitiesResponse['message'] ?? 'Failed to load dashboard data';
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading dashboard data: ${error.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: NeomorphicAppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(_isOnline ? Icons.cloud_done : Icons.cloud_off),
            onPressed: () {
              setState(() {
                _isOnline = !_isOnline;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ApiService().logout();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Uber Clone Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'System Management Portal',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: AppTheme.primaryColor),
              title: const Text('Dashboard'),
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: AppTheme.primaryColor),
              title: const Text('Users Management'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UsersManagementScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_taxi, color: AppTheme.primaryColor),
              title: const Text('Rides Management'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RidesManagementScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.monitor_heart, color: AppTheme.primaryColor),
              title: const Text('System Health'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SystemHealthScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.report_problem, color: AppTheme.primaryColor),
              title: const Text('Dispute Resolution'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DisputeResolutionScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics, color: AppTheme.primaryColor),
              title: const Text('Analytics & Reports'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnalyticsScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings, color: AppTheme.primaryColor),
              title: const Text('System Configuration'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConfigurationScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.security, color: AppTheme.primaryColor),
              title: const Text('Security Settings'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Security Settings feature coming soon'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.monitor, color: AppTheme.primaryColor),
              title: const Text('Real-time Monitoring'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RealtimeMonitoringScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.help, color: AppTheme.primaryColor),
              title: const Text('Help & Support'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Help & Support feature coming soon'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Banner
              NeomorphicCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome, Administrator!',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Monitor and manage the entire ride-sharing system with real-time insights',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _isOnline ? AppTheme.successColor : AppTheme.errorColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isOnline ? 'System Online' : 'System Offline',
                            style: TextStyle(
                              color: _isOnline ? AppTheme.successColor : AppTheme.errorColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          NeomorphicButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('System notifications enabled'),
                                  backgroundColor: AppTheme.successColor,
                                ),
                              );
                            },
                            width: 180,
                            height: 40,
                            child: const Text('Enable Notifications'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Stats Overview
              const Text(
                'System Overview',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              
              const SizedBox(height: 16),
              
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_errorMessage.isNotEmpty)
                NeomorphicCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: AppTheme.errorColor),
                    ),
                  ),
                )
              else if (_dashboardStats != null)
                ..._buildStatsCards(_dashboardStats!)
              else
                NeomorphicCard(
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No dashboard data available'),
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              
              const SizedBox(height: 16),
              
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildQuickActionCard(
                    Icons.people,
                    'Manage Users',
                    'View and manage all users in the system',
                    AppTheme.primaryGradient,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UsersManagementScreen(),
                        ),
                      );
                    },
                  ),
                  _buildQuickActionCard(
                    Icons.local_taxi,
                    'Manage Rides',
                    'Monitor and oversee all ride activities',
                    AppTheme.primaryGradient,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RidesManagementScreen(),
                        ),
                      );
                    },
                  ),
                  _buildQuickActionCard(
                    Icons.monitor_heart,
                    'System Health',
                    'Check the status of all system services',
                    AppTheme.primaryGradient,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SystemHealthScreen(),
                        ),
                      );
                    },
                  ),
                  _buildQuickActionCard(
                    Icons.report_problem,
                    'Resolve Disputes',
                    'Handle user complaints and disputes',
                    AppTheme.primaryGradient,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DisputeResolutionScreen(),
                        ),
                      );
                    },
                  ),
                  _buildQuickActionCard(
                    Icons.analytics,
                    'Analytics',
                    'View system performance metrics',
                    AppTheme.primaryGradient,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AnalyticsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildQuickActionCard(
                    Icons.settings,
                    'Configuration',
                    'System settings and preferences',
                    AppTheme.primaryGradient,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConfigurationScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Recent Activity
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              
              const SizedBox(height: 16),
              
              NeomorphicCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'System Status: Operational',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: AppTheme.successColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'All systems operational',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Latest Updates:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_recentActivities.isEmpty)
                        const Text(
                          'No recent activities',
                          style: TextStyle(
                            color: AppTheme.textSecondaryColor,
                          ),
                        )
                      else
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: _recentActivities.length > 5 ? 5 : _recentActivities.length,
                            itemBuilder: (context, index) {
                              final activity = _recentActivities[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _getActivityColor(activity['type']),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        activity['message'],
                                        style: const TextStyle(
                                          color: AppTheme.textSecondaryColor,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      activity['time'],
                                      style: const TextStyle(
                                        color: AppTheme.textSecondaryColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // System Performance
              const Text(
                'System Performance',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              
              const SizedBox(height: 16),
              
              NeomorphicCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildPerformanceIndicator('API Response Time', 45, 'ms', AppTheme.successColor),
                      const SizedBox(height: 16),
                      _buildPerformanceIndicator('Database Queries', 120, '/min', AppTheme.warningColor),
                      const SizedBox(height: 16),
                      _buildPerformanceIndicator('Active Connections', 856, '', AppTheme.primaryColor),
                      const SizedBox(height: 16),
                      _buildPerformanceIndicator('Error Rate', 0.1, '%', AppTheme.successColor),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getActivityColor(String type) {
    switch (type) {
      case 'user':
        return AppTheme.primaryColor;
      case 'ride':
        return AppTheme.accentColor;
      case 'system':
        return AppTheme.primaryColor;
      default:
        return AppTheme.textSecondaryColor;
    }
  }
  
  Widget _buildPerformanceIndicator(String label, double value, String unit, Color color) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.textColor,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '$value$unit',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Expanded(
          flex: 3,
          child: LayoutBuilder(
            builder: (context, constraints) {
              double percentage = (value / 100) * 100;
              if (label == 'API Response Time') {
                percentage = (100 - value); // Lower is better
              } else if (label == 'Error Rate') {
                percentage = (100 - (value * 10)); // Lower is better
              }
              
              return Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.textSecondaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  List<Widget> _buildStatsCards(Map<String, dynamic> stats) {
    return [
      GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildStatCard(
            'Active Users',
            stats['activeUsers'].toString(),
            Icons.people,
            AppTheme.primaryColor,
          ),
          _buildStatCard(
            'Active Drivers',
            stats['activeDrivers'].toString(),
            Icons.local_taxi,
            AppTheme.accentColor,
          ),
          _buildStatCard(
            'Daily Rides',
            stats['dailyRides'].toString(),
            Icons.directions_car,
            AppTheme.primaryColor,
          ),
          _buildStatCard(
            'Daily Revenue',
            '\$${stats['dailyRevenue'].toStringAsFixed(2)}',
            Icons.attach_money,
            AppTheme.successColor,
          ),
        ],
      ),
      const SizedBox(height: 16),
      GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildStatCard(
            'Avg. Rating',
            stats['averageRating'].toString(),
            Icons.star,
            Colors.amber,
          ),
          _buildStatCard(
            'Completion Rate',
            '${stats['completionRate'].toStringAsFixed(1)}%',
            Icons.check_circle,
            AppTheme.successColor,
          ),
          _buildStatCard(
            'Avg. Wait Time',
            '${stats['averageWaitTime'].toStringAsFixed(1)} min',
            Icons.access_time,
            AppTheme.warningColor,
          ),
        ],
      ),
    ];
  }
  
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return NeomorphicCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickActionCard(
    IconData icon,
    String title,
    String description,
    LinearGradient gradient,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: NeomorphicCard(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 24, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}