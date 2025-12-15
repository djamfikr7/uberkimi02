import 'package:flutter/material.dart';
import 'package:uber_shared/widgets/neomorphic_app_bar.dart';
import 'package:uber_shared/widgets/neomorphic_card.dart';
import 'package:uber_shared/widgets/neomorphic_button.dart';
import 'package:uber_shared/widgets/neomorphic_text_field.dart';
import 'package:admin_app/theme/app_theme.dart';
import 'package:admin_app/services/api_service.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({super.key});

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen> {
  bool _isLoading = false;
  String _errorMessage = '';
  String _successMessage = '';
  
  // Form controllers
  final TextEditingController _appNameController = TextEditingController(text: 'Uber Clone');
  final TextEditingController _supportEmailController = TextEditingController(text: 'support@uberclone.com');
  final TextEditingController _supportPhoneController = TextEditingController(text: '+1-800-UBERCLONE');
  final TextEditingController _cancellationFeeController = TextEditingController(text: '5.00');
  final TextEditingController _waitingTimeThresholdController = TextEditingController(text: '5');
  final TextEditingController _commissionRateController = TextEditingController(text: '25');
  
  // Toggle states
  bool _enableRatings = true;
  bool _enableChat = true;
  bool _enableNotifications = true;
  bool _enableFraudDetection = true;
  bool _enableAutoAssign = true;

  @override
  void initState() {
    super.initState();
    _loadConfiguration();
  }

  Future<void> _loadConfiguration() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // For now, we'll use mock data since the API doesn't have this endpoint yet
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Error loading configuration: ${error.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveConfiguration() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _successMessage = '';
    });

    try {
      // For now, we'll use mock data since the API doesn't have this endpoint yet
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _isLoading = false;
        _successMessage = 'Configuration saved successfully';
      });
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configuration saved successfully'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } catch (error) {
      setState(() {
        _errorMessage = 'Error saving configuration: ${error.toString()}';
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving configuration: ${error.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: NeomorphicAppBar(
        title: const Text('System Configuration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadConfiguration,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveConfiguration,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadConfiguration,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              NeomorphicCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'System Configuration',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Manage system-wide settings and preferences',
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // General Settings
              const Text(
                'General Settings',
                style: TextStyle(
                  fontSize: 20,
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
                      NeomorphicTextField(
                        controller: _appNameController,
                        hintText: 'App Name',
                        prefixIcon: Icons.app_registration,
                      ),
                      const SizedBox(height: 16),
                      NeomorphicTextField(
                        controller: _supportEmailController,
                        hintText: 'Support Email',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      NeomorphicTextField(
                        controller: _supportPhoneController,
                        hintText: 'Support Phone',
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Ride Settings
              const Text(
                'Ride Settings',
                style: TextStyle(
                  fontSize: 20,
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
                      NeomorphicTextField(
                        controller: _cancellationFeeController,
                        hintText: 'Cancellation Fee (\$)',
                        prefixIcon: Icons.money,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      NeomorphicTextField(
                        controller: _waitingTimeThresholdController,
                        hintText: 'Waiting Time Threshold (minutes)',
                        prefixIcon: Icons.access_time,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      NeomorphicTextField(
                        controller: _commissionRateController,
                        hintText: 'Commission Rate (%)',
                        prefixIcon: Icons.percent,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Feature Toggles
              const Text(
                'Feature Toggles',
                style: TextStyle(
                  fontSize: 20,
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
                      _buildToggleOption(
                        'Enable Ratings',
                        'Allow users to rate drivers and rides',
                        _enableRatings,
                        (value) {
                          setState(() {
                            _enableRatings = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildToggleOption(
                        'Enable Chat',
                        'Enable real-time chat between riders and drivers',
                        _enableChat,
                        (value) {
                          setState(() {
                            _enableChat = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildToggleOption(
                        'Enable Notifications',
                        'Send push notifications for ride updates',
                        _enableNotifications,
                        (value) {
                          setState(() {
                            _enableNotifications = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildToggleOption(
                        'Enable Fraud Detection',
                        'Detect and prevent fraudulent activities',
                        _enableFraudDetection,
                        (value) {
                          setState(() {
                            _enableFraudDetection = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildToggleOption(
                        'Enable Auto Assign',
                        'Automatically assign rides to nearby drivers',
                        _enableAutoAssign,
                        (value) {
                          setState(() {
                            _enableAutoAssign = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // System Maintenance
              const Text(
                'System Maintenance',
                style: TextStyle(
                  fontSize: 20,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Maintenance Mode',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.textColor,
                            ),
                          ),
                          Switch(
                            value: false,
                            onChanged: (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Maintenance mode feature coming soon'),
                                  backgroundColor: AppTheme.primaryColor,
                                ),
                              );
                            },
                            activeColor: AppTheme.primaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Scheduled Maintenance',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'No maintenance scheduled',
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Save Button
              Center(
                child: NeomorphicButton(
                  onPressed: _saveConfiguration,
                  width: 200,
                  height: 50,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text('Save Configuration'),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildToggleOption(
    String title,
    String description,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primaryColor,
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    _appNameController.dispose();
    _supportEmailController.dispose();
    _supportPhoneController.dispose();
    _cancellationFeeController.dispose();
    _waitingTimeThresholdController.dispose();
    _commissionRateController.dispose();
    super.dispose();
  }
}