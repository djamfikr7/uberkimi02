import 'package:flutter/material.dart';
import 'package:uber_shared/widgets/neomorphic_app_bar.dart';
import 'package:uber_shared/widgets/neomorphic_card.dart';
import 'package:uber_shared/widgets/neomorphic_button.dart';
import 'package:admin_app/theme/app_theme.dart';
import 'package:admin_app/services/api_service.dart';

class DisputeResolutionScreen extends StatefulWidget {
  const DisputeResolutionScreen({super.key});

  @override
  State<DisputeResolutionScreen> createState() => _DisputeResolutionScreenState();
}

class _DisputeResolutionScreenState extends State<DisputeResolutionScreen> {
  List<dynamic> _disputes = [];
  bool _isLoading = true;
  String _errorMessage = '';
  int _currentPage = 1;
  int _totalPages = 1;
  String _statusFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadDisputes();
  }

  Future<void> _loadDisputes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // For now, we'll use mock data since the API doesn't have this endpoint yet
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _disputes = [
          {
            'id': 'dispute_1',
            'rideId': 'ride_123',
            'userId': 'user_456',
            'userName': 'John Doe',
            'driverId': 'driver_789',
            'driverName': 'Jane Smith',
            'type': 'payment',
            'status': 'pending',
            'description': 'Disputed cash payment amount',
            'amount': 15.50,
            'createdAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
            'resolvedAt': null,
          },
          {
            'id': 'dispute_2',
            'rideId': 'ride_456',
            'userId': 'user_789',
            'userName': 'Alice Johnson',
            'driverId': 'driver_123',
            'driverName': 'Bob Wilson',
            'type': 'service',
            'status': 'in_progress',
            'description': 'Rude driver behavior',
            'amount': 0,
            'createdAt': DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
            'resolvedAt': null,
          },
          {
            'id': 'dispute_3',
            'rideId': 'ride_789',
            'userId': 'user_123',
            'userName': 'Charlie Brown',
            'driverId': 'driver_456',
            'driverName': 'Diana Miller',
            'type': 'cancellation',
            'status': 'resolved',
            'description': 'Unjustified ride cancellation',
            'amount': 5.00,
            'createdAt': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
            'resolvedAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
          },
        ];
        _totalPages = 1;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Error loading disputes: ${error.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshDisputes() async {
    _loadDisputes();
  }

  Future<void> _changePage(int page) async {
    setState(() {
      _currentPage = page;
    });
    _loadDisputes();
  }

  void _filterByStatus(String status) {
    setState(() {
      _statusFilter = status;
      _currentPage = 1;
    });
    _loadDisputes();
  }

  Future<void> _resolveDispute(String disputeId) async {
    try {
      // For now, we'll use mock data since the API doesn't have this endpoint yet
      await Future.delayed(const Duration(seconds: 1));
      
      // Update the dispute in the list
      setState(() {
        for (var i = 0; i < _disputes.length; i++) {
          if (_disputes[i]['id'] == disputeId) {
            _disputes[i]['status'] = 'resolved';
            _disputes[i]['resolvedAt'] = DateTime.now().toIso8601String();
            break;
          }
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dispute resolved successfully'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error resolving dispute: ${error.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  Future<void> _rejectDispute(String disputeId) async {
    try {
      // For now, we'll use mock data since the API doesn't have this endpoint yet
      await Future.delayed(const Duration(seconds: 1));
      
      // Update the dispute in the list
      setState(() {
        for (var i = 0; i < _disputes.length; i++) {
          if (_disputes[i]['id'] == disputeId) {
            _disputes[i]['status'] = 'rejected';
            _disputes[i]['resolvedAt'] = DateTime.now().toIso8601String();
            break;
          }
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dispute rejected'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error rejecting dispute: ${error.toString()}'),
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
        title: const Text('Dispute Resolution'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshDisputes,
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
                const Text(
                  'Filter by status:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _statusFilter,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                    DropdownMenuItem(value: 'resolved', child: Text('Resolved')),
                    DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      _filterByStatus(value);
                    }
                  },
                ),
                const Spacer(),
                NeomorphicButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Export disputes feature coming soon'),
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    );
                  },
                  width: 120,
                  height: 40,
                  child: const Text('Export'),
                ),
              ],
            ),
          ),
          
          // Disputes list
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshDisputes,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _errorMessage,
                                style: const TextStyle(color: AppTheme.errorColor),
                              ),
                              const SizedBox(height: 16),
                              NeomorphicButton(
                                onPressed: _loadDisputes,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _disputes.isEmpty
                          ? const Center(
                              child: Text(
                                'No disputes found',
                                style: TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: _disputes.length + 1,
                              itemBuilder: (context, index) {
                                if (index == _disputes.length) {
                                  // Pagination controls
                                  return _buildPaginationControls();
                                }
                                return _buildDisputeCard(_disputes[index]);
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisputeCard(dynamic dispute) {
    return NeomorphicCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${dispute['id'].substring(0, 8)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                Chip(
                  label: Text(
                    dispute['status'].replaceAll('_', ' '),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: _getStatusColor(dispute['status']),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: AppTheme.textSecondaryColor),
                const SizedBox(width: 8),
                Text(
                  'User: ${dispute['userName']}',
                  style: const TextStyle(fontSize: 14, color: AppTheme.textColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.local_taxi, size: 16, color: AppTheme.textSecondaryColor),
                const SizedBox(width: 8),
                Text(
                  'Driver: ${dispute['driverName']}',
                  style: const TextStyle(fontSize: 14, color: AppTheme.textColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.confirmation_number, size: 16, color: AppTheme.textSecondaryColor),
                const SizedBox(width: 8),
                Text(
                  'Ride: #${dispute['rideId'].substring(0, 8)}',
                  style: const TextStyle(fontSize: 14, color: AppTheme.textColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTypeColor(dispute['type']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    dispute['type'].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (dispute['amount'] > 0)
                  Text(
                    '\$${dispute['amount'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              dispute['description'],
              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Created: ${DateTime.parse(dispute['createdAt']).toString().split(' ')[0]}',
                  style: const TextStyle(
                    color: AppTheme.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
                if (dispute['resolvedAt'] != null)
                  Text(
                    'Resolved: ${DateTime.parse(dispute['resolvedAt']).toString().split(' ')[0]}',
                    style: const TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (dispute['status'] == 'pending' || dispute['status'] == 'in_progress')
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  NeomorphicButton(
                    onPressed: () {
                      _showDisputeDetailsDialog(dispute);
                    },
                    width: 120,
                    height: 36,
                    child: const Text('View Details'),
                  ),
                  const SizedBox(width: 8),
                  NeomorphicButton(
                    onPressed: () {
                      _rejectDispute(dispute['id']);
                    },
                    width: 100,
                    height: 36,
                    child: const Text('Reject'),
                  ),
                  const SizedBox(width: 8),
                  NeomorphicButton(
                    onPressed: () {
                      _resolveDispute(dispute['id']);
                    },
                    width: 100,
                    height: 36,
                    child: const Text('Resolve'),
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  NeomorphicButton(
                    onPressed: () {
                      _showDisputeDetailsDialog(dispute);
                    },
                    width: 120,
                    height: 36,
                    child: const Text('View Details'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showDisputeDetailsDialog(dynamic dispute) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.backgroundColor,
          title: Text(
            'Dispute Details #${dispute['id'].substring(0, 8)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('User', dispute['userName']),
                _buildDetailRow('Driver', dispute['driverName']),
                _buildDetailRow('Ride ID', '#${dispute['rideId'].substring(0, 8)}'),
                _buildDetailRow('Type', dispute['type']),
                _buildDetailRow('Status', dispute['status']),
                if (dispute['amount'] > 0)
                  _buildDetailRow('Amount', '\$${dispute['amount'].toStringAsFixed(2)}'),
                _buildDetailRow('Description', dispute['description']),
                _buildDetailRow('Created', DateTime.parse(dispute['createdAt']).toString()),
                if (dispute['resolvedAt'] != null)
                  _buildDetailRow('Resolved', DateTime.parse(dispute['resolvedAt']).toString()),
              ],
            ),
          ),
          actions: [
            NeomorphicButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              width: 100,
              height: 36,
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppTheme.warningColor;
      case 'in_progress':
        return AppTheme.primaryColor;
      case 'resolved':
        return AppTheme.successColor;
      case 'rejected':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondaryColor;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'payment':
        return AppTheme.successColor;
      case 'service':
        return AppTheme.primaryColor;
      case 'cancellation':
        return AppTheme.warningColor;
      default:
        return AppTheme.textSecondaryColor;
    }
  }

  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Page $_currentPage of $_totalPages',
            style: const TextStyle(
              color: AppTheme.textSecondaryColor,
            ),
          ),
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