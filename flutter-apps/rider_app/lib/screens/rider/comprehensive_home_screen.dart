import 'package:flutter/material.dart';
import 'package:uber_shared/uber_shared.dart';
import 'package:rider_app/screens/rider/ride_request_screen.dart' as ride_request;
import 'package:rider_app/screens/rider/rider_home_screen.dart' as rider_home;

class ComprehensiveHomeScreen extends StatefulWidget {
  const ComprehensiveHomeScreen({super.key});

  @override
  State<ComprehensiveHomeScreen> createState() => _ComprehensiveHomeScreenState();
}

class _ComprehensiveHomeScreenState extends State<ComprehensiveHomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeomorphicAppBar(
        title: const Text('Uber Clone'),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const rider_home.ProfileTab()
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
          const HomeTab(),
          const rider_home.RidesTab(),
          const rider_home.SafetyTab(),
          const rider_home.ProfileTab(),
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
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Rides',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security_outlined),
            activeIcon: Icon(Icons.security),
            label: 'Safety',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: NeomorphicFab(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ride_request.RideRequestScreen(),
            ),
          );
        },
        child: const Icon(Icons.directions_car),
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
          // Welcome Message
          Text(
            'Hello there!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Where are you going?',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),

          // Location Search Card
          NeomorphicCard(
            child: Column(
              children: [
                // Where to field
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Where to?',
                    prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  onTap: () {
                    // TODO: Implement location search
                  },
                ),
                const Divider(height: 1),
                // Current location
                ListTile(
                  leading: const Icon(Icons.my_location, color: AppTheme.primaryLight),
                  title: const Text('Current Location'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Set current location as pickup
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Quick Destinations
          Text(
            'Saved Places',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDestinationCard(
                  context,
                  Icons.home,
                  'Home',
                  '123 Main Street',
                  AppTheme.primaryLight,
                ),
                const SizedBox(width: 12),
                _buildDestinationCard(
                  context,
                  Icons.work,
                  'Work',
                  '456 Business Ave',
                  AppTheme.accentStart,
                ),
                const SizedBox(width: 12),
                _buildDestinationCard(
                  context,
                  Icons.favorite,
                  'Favorite',
                  '789 Park Lane',
                  AppTheme.error,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Vehicle Types
          Text(
            'Choose a ride',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildVehicleOption(
                  context,
                  'UberX',
                  'Affordable',
                  '\$12-18',
                  Icons.car_crash,
                  true,
                ),
                const SizedBox(width: 12),
                _buildVehicleOption(
                  context,
                  'Comfort',
                  'Extra legroom',
                  '\$18-25',
                  Icons.airline_seat_recline_extra,
                  false,
                ),
                const SizedBox(width: 12),
                _buildVehicleOption(
                  context,
                  'Black',
                  'Premium',
                  '\$25-35',
                  Icons.local_taxi,
                  false,
                ),
                const SizedBox(width: 12),
                _buildVehicleOption(
                  context,
                  'Pool',
                  'Shared ride',
                  '\$8-12',
                  Icons.people,
                  false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Promotions
          Text(
            'Promotions',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          NeomorphicCard(
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: AppTheme.accentGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_offer, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '10% off your next ride',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Use code: WELCOME10',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                NeomorphicButton(
                  onPressed: () {
                    // TODO: Apply promotion
                  },
                  width: 80,
                  height: 36,
                  child: const Text('Apply', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return NeomorphicCard(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleOption(
    BuildContext context,
    String title,
    String subtitle,
    String price,
    IconData icon,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        // TODO: Select vehicle type
      },
      child: NeomorphicCard(
        width: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: isSelected ? AppTheme.primaryLight : AppTheme.textSecondary),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.primaryLight : AppTheme.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}