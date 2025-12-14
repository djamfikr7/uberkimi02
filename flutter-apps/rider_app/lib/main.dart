import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rider_app/screens/auth/login_screen.dart';
import 'package:rider_app/screens/rider/rider_home_screen.dart';
import 'package:rider_app/theme/app_theme.dart';
import 'package:rider_app/models/user_model.dart';
import 'package:rider_app/services/api_service.dart';
import 'package:rider_app/config/environment.dart';
import 'package:rider_app/config/dev_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Print environment configuration
  Environment.printConfig();

  runApp(const RiderApp());
}

class RiderApp extends StatelessWidget {
  const RiderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber Clone Rider',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const RiderHomeScreen(),
      },
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
        // For development: bypass authentication and auto-login as demo rider
        final user = await apiService.demoLoginRider();
        
        if (user.isRider) {
          setState(() {
            _currentUser = user;
            _isLoading = false;
          });
        } else {
          // If not a rider, show login screen
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
          if (user != null && user.isRider) {
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
      return const LoginScreen();
    }

    // Only allow rider users
    if (_currentUser!.isRider) {
      return const RiderHomeScreen();
    } else {
      // If not a rider, logout and go to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ApiService().logout();
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
        ),
      );
    }
  }
}