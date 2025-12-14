import 'package:flutter/material.dart';
import 'package:admin_app/theme/app_theme.dart';
import 'package:admin_app/services/api_service.dart';

class SystemHealthScreen extends StatefulWidget {
  const SystemHealthScreen({super.key});

  @override
  State<SystemHealthScreen> createState() => _SystemHealthScreenState();
}

class _SystemHealthScreenState extends State<SystemHealthScreen> {
  Map<String, dynamic>? _healthData;
  bool _isLoading = true;
  String _errorMessage = '';
  late DateTime _lastUpdated;

  @override
  void initState() {
    super.initState();
    _loadHealthData();
  }

  Future<void> _loadHealthData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await ApiService().getSystemHealth();

      if (response['success'] && mounted) {
        setState(() {
          _healthData = response['data']['health'];
          _lastUpdated = DateTime.now();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Failed to load health data';
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading health data: ${error.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshHealthData() async {
    _loadHealthData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Health'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshHealthData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshHealthData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Card(
                color: AppTheme.surfaceColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'System Health Dashboard',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Last updated: ${_lastUpdated.toString().split('.')[0]}',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildOverallStatus(),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Services status
              const Text(
                'Services Status',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_errorMessage.isNotEmpty)
                Card(
                  color: AppTheme.errorColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              else if (_healthData != null)
                ..._buildServicesList()
              else
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No health data available'),
                  ),
                ),
              
              const SizedBox(height: 20),
              
              // Performance Metrics
              const Text(
                'Performance Metrics',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              if (_healthData != null && _healthData!['metrics'] != null)
                ..._buildMetricsList()
              else
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No performance metrics available'),
                  ),
                ),
              
              const SizedBox(height: 20),
              
              // Actions
              const Text(
                'System Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildActionCard(
                    Icons.restart_alt,
                    'Restart Services',
                    'Restart all system services',
                    AppTheme.warningColor,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Restart services feature coming soon'),
                        ),
                      );
                    },
                  ),
                  _buildActionCard(
                    Icons.cleaning_services,
                    'Clear Cache',
                    'Clear system cache and temporary files',
                    AppTheme.primaryColor,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Clear cache feature coming soon'),
                        ),
                      );
                    },
                  ),
                  _buildActionCard(
                    Icons.update,
                    'Update System',
                    'Check for and apply system updates',
                    AppTheme.successColor,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Update system feature coming soon'),
                        ),
                      );
                    },
                  ),
                  _buildActionCard(
                    Icons.download,
                    'Backup Data',
                    'Create a backup of all system data',
                    AppTheme.secondaryColor,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Backup data feature coming soon'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallStatus() {
    if (_healthData == null) {
      return const Text('Unknown status');
    }

    final status = _healthData!['status'];
    final isHealthy = status == 'healthy';
    
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isHealthy ? AppTheme.successColor : AppTheme.errorColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          isHealthy ? 'System Operational' : 'System Issues Detected',
          style: TextStyle(
            color: isHealthy ? AppTheme.successColor : AppTheme.errorColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildServicesList() {
    final services = _healthData!['services'] as Map<String, dynamic>;
    final serviceEntries = services.entries.toList();

    return [
      GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: serviceEntries.map((entry) {
          final serviceName = entry.key;
          final serviceStatus = entry.value.toString();
          final isHealthy = serviceStatus == 'connected' || serviceStatus == 'healthy';
          
          return Card(
            color: isHealthy ? AppTheme.successColor.withOpacity(0.1) : AppTheme.errorColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isHealthy ? Icons.check_circle : Icons.error,
                    size: 32,
                    color: isHealthy ? AppTheme.successColor : AppTheme.errorColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    serviceName.replaceAll(RegExp(r'([A-Z])'), ' \$1').trim(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    serviceStatus,
                    style: TextStyle(
                      fontSize: 12,
                      color: isHealthy ? AppTheme.successColor : AppTheme.errorColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ];
  }

  List<Widget> _buildMetricsList() {
    final metrics = _healthData!['metrics'] as Map<String, dynamic>;
    final metricEntries = metrics.entries.toList();

    return [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: metricEntries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key.replaceAll(RegExp(r'([A-Z])'), ' \$1').trim(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      entry.value.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    ];
  }

  Widget _buildActionCard(
    IconData icon,
    String title,
    String description,
    Color color,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Card(
        elevation: 4,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 32, color: color),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
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