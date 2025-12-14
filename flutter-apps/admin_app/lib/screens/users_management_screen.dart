import 'package:flutter/material.dart';
import 'package:admin_app/theme/app_theme.dart';
import 'package:admin_app/services/api_service.dart';

class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({super.key});

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  List<dynamic> _users = [];
  bool _isLoading = true;
  String _errorMessage = '';
  int _currentPage = 1;
  int _totalPages = 1;
  String _userTypeFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await ApiService().getAllUsers(
        page: _currentPage,
        limit: 10,
        type: _userTypeFilter == 'all' ? null : _userTypeFilter,
      );

      if (response['success'] && mounted) {
        setState(() {
          _users = List<dynamic>.from(response['data']['users']);
          _totalPages = response['data']['totalPages'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Failed to load users';
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading users: ${error.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshUsers() async {
    _loadUsers();
  }

  Future<void> _changePage(int page) async {
    setState(() {
      _currentPage = page;
    });
    _loadUsers();
  }

  void _filterByType(String type) {
    setState(() {
      _userTypeFilter = type;
      _currentPage = 1;
    });
    _loadUsers();
  }

  Future<void> _toggleUserStatus(String userId, String currentStatus) async {
    try {
      final newStatus = currentStatus == 'active' ? 'suspended' : 'active';
      final response = await ApiService().updateUserStatus(userId, newStatus);

      if (response['success']) {
        // Update the user in the list
        setState(() {
          for (var i = 0; i < _users.length; i++) {
            if (_users[i]['id'] == userId) {
              _users[i]['status'] = newStatus;
              break;
            }
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User status updated to $newStatus'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Failed to update user status'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating user status: ${error.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users Management'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshUsers,
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
                const Text('Filter by type:'),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _userTypeFilter,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'rider', child: Text('Riders')),
                    DropdownMenuItem(value: 'driver', child: Text('Drivers')),
                    DropdownMenuItem(value: 'admin', child: Text('Admins')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      _filterByType(value);
                    }
                  },
                ),
              ],
            ),
          ),
          
          // Users list
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshUsers,
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
                                onPressed: _loadUsers,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _users.isEmpty
                          ? const Center(
                              child: Text('No users found'),
                            )
                          : ListView.builder(
                              itemCount: _users.length + 1,
                              itemBuilder: (context, index) {
                                if (index == _users.length) {
                                  // Pagination controls
                                  return _buildPaginationControls();
                                }
                                return _buildUserCard(_users[index]);
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(dynamic user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryColor,
                  child: Text(
                    user['firstName'][0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user['firstName']} ${user['lastName']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user['email'],
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        user['phoneNumber'] ?? 'No phone number',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(user['userType']),
                  backgroundColor: user['userType'] == 'rider'
                      ? AppTheme.primaryColor.withOpacity(0.3)                      : user['userType'] == 'driver'
                          ? AppTheme.successColor
                          : AppTheme.warningColor,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(user['status']),
                  backgroundColor: user['status'] == 'active'
                      ? AppTheme.successColor
                      : AppTheme.errorColor,
                ),
                Text(
                  'Joined: ${DateTime.parse(user['createdAt']).toString().split(' ')[0]}',
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
                ElevatedButton.icon(
                  onPressed: () => _toggleUserStatus(user['id'], user['status']),
                  icon: Icon(
                    user['status'] == 'active' ? Icons.block : Icons.check,
                  ),
                  label: Text(
                    user['status'] == 'active' ? 'Suspend' : 'Activate',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: user['status'] == 'active'
                        ? AppTheme.errorColor
                        : AppTheme.successColor,
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    // View details action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User details feature coming soon'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('View Details'),
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