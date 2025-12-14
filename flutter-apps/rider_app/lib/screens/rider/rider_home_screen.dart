import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rider_app/theme/app_theme.dart';
import 'package:rider_app/models/user_model.dart';
import 'package:rider_app/services/api_service.dart';
import 'package:rider_app/screens/rider/ride_request_screen.dart';
import 'package:uber_shared/map_widget.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({super.key});

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _handleLogout() async {
    await ApiService().logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uber Clone Rider'),
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
        children: const [
          HomeTab(),
          RidesTab(),
          SafetyTab(),
          ProfileTab(),
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Rides',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: 'Safety',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to ride request screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RideRequestScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// Home Tab
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Location Search
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Where to?'),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter destination',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          SizedBox(
            height: 150,
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildActionCard(context, Icons.home, 'Home', AppTheme.primaryColor),
                _buildActionCard(context, Icons.work, 'Work', AppTheme.secondaryColor),
                _buildActionCard(context, Icons.favorite, 'Saved', Colors.red),
                _buildActionCard(context, Icons.history, 'Recent', Colors.green),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Vehicle Types
          const Text(
            'Vehicle Types',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildVehicleCard(context, 'UberX', 'Affordable rides', '\$12-18', Icons.car_crash),
                _buildVehicleCard(context, 'Comfort', 'Extra legroom', '\$18-25', Icons.airline_seat_recline_extra),
                _buildVehicleCard(context, 'Black', 'Premium rides', '\$25-35', Icons.local_taxi),
                _buildVehicleCard(context, 'Pool', 'Shared rides', '\$8-12', Icons.people),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Promotions
          const Text(
            'Promotions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.local_offer, size: 40),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('10% off your next ride'),
                        Text(
                          'Use code: WELCOME10',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, IconData icon, String label, Color color) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, String name, String description, String price, IconData icon) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(description, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
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
          'Rides History\n\nView your past rides and trip details here.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// Safety Tab
class SafetyTab extends StatelessWidget {
  const SafetyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Safety Features\n\nAccess emergency contacts, ride verification, and incident reporting here.',
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
          'User Profile\n\nManage your account settings, payment methods, and preferences here.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// Ride Request Screen
class RideRequestScreen extends StatefulWidget {
  const RideRequestScreen({super.key});

  @override
  State<RideRequestScreen> createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  String _selectedVehicleType = 'UberX';
  LatLng? _pickupLocation;
  LatLng? _dropoffLocation;
  String? _pickupAddress;
  String? _dropoffAddress;

  Widget _buildMap() {
    return UniversalMapWidget(
      markers: [
        Marker(
          point: LatLng(MapConfig.defaultLatitude, MapConfig.defaultLongitude),
          child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Ride'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Map View (supports both OpenStreetMap and Mapbox)
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildMap(),
            ),

            const SizedBox(height: 16),

            // Location Fields
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.circle, size: 12, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: _pickupAddress ?? 'Pickup Location',
                              border: InputBorder.none,
                            ),
                            onTap: () async {
                              // Navigate to map selection for pickup
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Map selection feature coming soon'),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 12, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: _dropoffAddress ?? 'Dropoff Location',
                              border: InputBorder.none,
                            ),
                            onTap: () async {
                              // Navigate to map selection for dropoff
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Map selection feature coming soon'),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Vehicle Type Selection
            const Text('Vehicle Type', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: [
                _buildVehicleChip('UberX', _selectedVehicleType == 'UberX'),
                _buildVehicleChip('Comfort', _selectedVehicleType == 'Comfort'),
                _buildVehicleChip('Black', _selectedVehicleType == 'Black'),
                _buildVehicleChip('Pool', _selectedVehicleType == 'Pool'),
              ],
            ),

            const SizedBox(height: 16),

            // Ride Details
            const Text('Ride Details', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Distance'),
                        Text('5.2 km', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Duration'),
                        Text('12 min', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Estimated Fare'),
                        Text('\$15.50', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Request Button
            ElevatedButton(
              onPressed: () {
                // Request ride logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ride requested successfully!')),
                );
                Navigator.pop(context);
              },
              child: const Text('Request Ride'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedVehicleType = label);
      },
      selectedColor: AppTheme.primaryColor,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
      ),
    );
  }
}