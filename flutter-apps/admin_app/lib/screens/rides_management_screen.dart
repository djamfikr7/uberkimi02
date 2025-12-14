import 'package:flutter/material.dart';
import 'package:admin_app/theme/app_theme.dart';
import 'package:admin_app/services/api_service.dart';

class RidesManagementScreen extends StatefulWidget {
  const RidesManagementScreen({super.key});

  @override
  State<RidesManagementScreen> createState() => _RidesManagementScreenState();
}

class _RidesManagementScreenState extends State<RidesManagementScreen> {
  List<dynamic> _rides = [];
  bool _isLoading = true;
  String _errorMessage = '';
  int _currentPage = 1;
  int _totalPages = 1;
  String _statusFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadRides();
  }

  Future<void> _loadRides() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await ApiService().getAllRides(
        page: _currentPage,
        limit: 10,
        status: _statusFilter == 'all' ? null : _statusFilter,
      );

      if (response['success'] && mounted) {
        setState(() {
          _rides = List<dynamic>.from(response['data']['rides']);
          _totalPages = response['data']['totalPages'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Failed to load rides';
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading rides: ${error.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshRides() async {
    _loadRides();
  }

  Future<void> _changePage(int page) async {
    setState(() {
      _currentPage = page;
    });
    _loadRides();
  }

  void _filterByStatus(String status) {
    setState(() {
      _statusFilter = status;
      _currentPage = 1;
    });
    _loadRides();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'requested':
        return AppTheme.warningColor;
      case 'accepted':
        return AppTheme.primaryColor;
      case 'in_progress':
        return AppTheme.primaryColor;
      case 'completed':
        return AppTheme.successColor;
      case 'cancelled':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondaryColor;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rides Management'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshRides,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Filter by status:'),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _statusFilter,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'requested', child: Text('Requested')),
                    DropdownMenuItem(value: 'accepted', child: Text('Accepted')),
                    DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                    DropdownMenuItem(value: 'completed', child: Text('Completed')),
                    DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      _filterByStatus(value);
                    }
                  },
                ),
              ],
            ),
          ),
          
          // Rides list
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshRides,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                              ElevatedButton(
                                onPressed: _loadRides,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _rides.isEmpty
                          ? const Center(
                              child: Text('No rides found'),
                            )
                          : ListView.builder(
                              itemCount: _rides.length + 1,
                              itemBuilder: (context, index) {
                                if (index == _rides.length) {
                                  // Pagination controls
                                  return _buildPaginationControls();
                                }
                                return _buildRideCard(_rides[index]);
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRideCard(dynamic ride) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${ride['id'].substring(0, 8)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(ride['status'].replaceAll('_', ' ')),
                  backgroundColor: _getStatusColor(ride['status']),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Rider: ${ride['riderId'].substring(0, 8)}...',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.local_taxi, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Driver: ${ride['driverId'].substring(0, 8)}...',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pickup: ${ride['pickupLocation']}',
                    style: const TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.flag, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Dropoff: ${ride['dropoffLocation']}',
                    style: const TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${ride['fare'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    Text(
                      '${ride['distanceKm'].toStringAsFixed(1)} km',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      ride['vehicleType'] ?? 'Standard',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ride['paymentMethod'] ?? 'cash',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Created: ${DateTime.parse(ride['createdAt']).toString().split(' ')[0]}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // View details action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ride details feature coming soon'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('View Details'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // Take action on ride
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ride action feature coming soon'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Take Action'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Page $_currentPage of $_totalPages'),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _currentPage > 1
                    ? () => _changePage(_currentPage - 1)
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _currentPage < _totalPages
                    ? () => _changePage(_currentPage + 1)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}