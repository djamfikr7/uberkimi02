import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:driver_app/theme/app_theme.dart';
import 'package:driver_app/models/user_model.dart';
import 'package:driver_app/services/api_service.dart';
import 'package:driver_app/config/environment.dart';
import 'package:driver_app/config/dev_config.dart';
import 'package:driver_app/screens/driver/comprehensive_driver_home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Print environment configuration
  Environment.printConfig();

  runApp(const DriverApp());
}

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber Clone Driver',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final apiService = ApiService();
      
      if (DevConfig.bypassAuth) {
        // For development: bypass authentication and auto-login as demo driver
        final user = await apiService.demoLoginDriver();
        
        if (user.isDriver) {
          setState(() {
            _currentUser = user;
            _isLoading = false;
          });
        } else {
          // If not a driver, show login screen
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        // Check if user is already authenticated
        final isAuthenticated = await apiService.isAuthenticated();

        if (isAuthenticated) {
          // Get current user
          final user = await apiService.getCurrentUser();
          if (user != null && user.isDriver) {
            setState(() {
              _currentUser = user;
              _isLoading = false;
            });
            return;
          }
        }

        // If not authenticated, show login screen directly
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      // If any error occurs, proceed to login screen
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
        ),
      );
    }

    if (_currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Login required'),
        ),
      );
    }

    // Only allow driver users
    if (_currentUser!.isDriver) {
      return const ComprehensiveDriverHomeScreen();
    } else {
      // If not a driver, logout and go to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ApiService().logout();
      });
      return const Scaffold(
        body: Center(
          child: Text('Unauthorized access'),
        ),
      );
    }
  }
}