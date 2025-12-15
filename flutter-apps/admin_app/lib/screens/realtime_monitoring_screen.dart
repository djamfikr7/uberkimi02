import 'package:flutter/material.dart';
import 'package:admin_app/theme/app_theme.dart';
import 'package:admin_app/services/api_service.dart';
import 'package:uber_shared/widgets/neomorphic_app_bar.dart';
import 'package:uber_shared/widgets/neomorphic_card.dart';
import 'package:uber_shared/widgets/neomorphic_button.dart';

class RealtimeMonitoringScreen extends StatefulWidget {
  const RealtimeMonitoringScreen({super.key});

  @override
  State<RealtimeMonitoringScreen> createState() => _RealtimeMonitoringScreenState();
}

class _RealtimeMonitoringScreenState extends State<RealtimeMonitoringScreen> {
  List<dynamic> _realtimeEvents = [];
  bool _isConnected = false;
  String _connectionStatus = 'Disconnected';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeSocketConnection();
  }

  Future<void> _initializeSocketConnection() async {
    try {
      final apiService = ApiService();
      _isConnected = apiService.isSocketConnected();
      setState(() {
        _connectionStatus = _isConnected ? 'Connected' : 'Disconnected';
      });
      
      // If not connected, try to connect
      if (!_isConnected) {
        // We'll assume the user is already authenticated
        // In a real implementation, we'd get the token from the auth system
        // For now, we'll just update the UI to show disconnected state
      }
    } catch (e) {
      setState(() {
        _connectionStatus = 'Error: ${e.toString()}';
      });
    }
  }

  void _connectToSocket() {
    // In a real implementation, this would connect to the socket
    // For now, we'll just simulate the connection
    setState(() {
      _isConnected = true;
      _connectionStatus = 'Connected';
    });
    
    // Simulate receiving events
    _simulateRealtimeEvents();
  }

  void _disconnectFromSocket() {
    setState(() {
      _isConnected = false;
      _connectionStatus = 'Disconnected';
      _realtimeEvents.clear();
    });
  }

  void _simulateRealtimeEvents() {
    // Simulate receiving real-time events
    Future.delayed(const Duration(seconds: 1), () {
      if (_isConnected && mounted) {
        setState(() {
          _realtimeEvents.insert(0, {
            'id': DateTime.now().millisecondsSinceEpoch,
            'type': 'ride',
            'message': 'New ride request #RID123456',
            'timestamp': DateTime.now(),
            'severity': 'info',
          });
        });
        _scrollToBottom();
      }
    });
    
    Future.delayed(const Duration(seconds: 3), () {
      if (_isConnected && mounted) {
        setState(() {
          _realtimeEvents.insert(0, {
            'id': DateTime.now().millisecondsSinceEpoch,
            'type': 'driver',
            'message': 'Driver John accepted ride #RID123456',
            'timestamp': DateTime.now(),
            'severity': 'success',
          });
        });
        _scrollToBottom();
      }
    });
    
    Future.delayed(const Duration(seconds: 5), () {
      if (_isConnected && mounted) {
        setState(() {
          _realtimeEvents.insert(0, {
            'id': DateTime.now().millisecondsSinceEpoch,
            'type': 'location',
            'message': 'Driver location updated for ride #RID123456',
            'timestamp': DateTime.now(),
            'severity': 'info',
          });
        });
        _scrollToBottom();
      }
    });
    
    Future.delayed(const Duration(seconds: 7), () {
      if (_isConnected && mounted) {
        setState(() {
          _realtimeEvents.insert(0, {
            'id': DateTime.now().millisecondsSinceEpoch,
            'type': 'ride',
            'message': 'Ride #RID123456 completed',
            'timestamp': DateTime.now(),
            'severity': 'success',
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: NeomorphicAppBar(
        title: const Text('Real-time Monitoring'),
        actions: [
          IconButton(
            icon: Icon(
              _isConnected ? Icons.link_off : Icons.link,
              color: _isConnected ? AppTheme.successColor : AppTheme.errorColor,
            ),
            onPressed: _isConnected ? _disconnectFromSocket : _connectToSocket,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Connection Status Card
          NeomorphicCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _isConnected ? AppTheme.successColor : AppTheme.errorColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Connection Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _connectionStatus,
                          style: TextStyle(
                            color: _isConnected ? AppTheme.successColor : AppTheme.errorColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  NeomorphicButton(
                    onPressed: _isConnected ? _disconnectFromSocket : _connectToSocket,
                    width: 120,
                    height: 40,
                    child: Text(_isConnected ? 'Disconnect' : 'Connect'),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Stats Overview
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildStatCard('Active Rides', '24', AppTheme.primaryColor),
                _buildStatCard('Available Drivers', '18', AppTheme.successColor),
                _buildStatCard('Pending Requests', '3', AppTheme.warningColor),
                _buildStatCard('Completed Today', '142', AppTheme.primaryColor),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Real-time Events Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Real-time Events',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear_all, color: AppTheme.textSecondaryColor),
                  onPressed: () {
                    setState(() {
                      _realtimeEvents.clear();
                    });
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Real-time Events List
          Expanded(
            child: NeomorphicCard(
              child: _realtimeEvents.isEmpty
                  ? const Center(
                      child: Text(
                        'No real-time events. Connect to start monitoring.',
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemCount: _realtimeEvents.length,
                      itemBuilder: (context, index) {
                        final event = _realtimeEvents[index];
                        return _buildEventItem(event);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      child: NeomorphicCard(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
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
      ),
    );
  }
  
  Widget _buildEventItem(dynamic event) {
    final eventType = event['type'];
    final message = event['message'];
    final timestamp = event['timestamp'] as DateTime;
    final severity = event['severity'];
    
    IconData icon;
    Color iconColor;
    
    switch (eventType) {
      case 'ride':
        icon = Icons.local_taxi;
        iconColor = severity == 'success' ? AppTheme.successColor : AppTheme.primaryColor;
        break;
      case 'driver':
        icon = Icons.person;
        iconColor = severity == 'success' ? AppTheme.successColor : AppTheme.warningColor;
        break;
      case 'location':
        icon = Icons.location_on;
        iconColor = AppTheme.primaryColor;
        break;
      case 'user':
        icon = Icons.people;
        iconColor = AppTheme.primaryColor;
        break;
      default:
        icon = Icons.info;
        iconColor = AppTheme.textSecondaryColor;
    }
    
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.surfaceColor,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          message,
          style: const TextStyle(
            color: AppTheme.textColor,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}',
          style: const TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 12,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}