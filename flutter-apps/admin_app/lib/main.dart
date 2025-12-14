import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:admin_app/theme/app_theme.dart';
import 'package:admin_app/models/user_model.dart';
import 'package:admin_app/services/api_service.dart';
import 'package:admin_app/config/environment.dart';
import 'package:admin_app/config/dev_config.dart';
import 'package:admin_app/screens/admin_dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Print environment configuration
  Environment.printConfig();

  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber Clone Admin',
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
        // For development: bypass authentication and auto-login as demo admin
        final user = await apiService.demoLoginAdmin();
        
        if (user.isAdmin) {
          setState(() {
            _currentUser = user;
            _isLoading = false;
          });
        } else {
          // If not an admin, show login screen
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
          if (user != null && user.isAdmin) {
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

    // Only allow admin users
    if (_currentUser!.isAdmin) {
      return const AdminDashboardScreen();
    } else {
      // If not an admin, logout and go to login
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
