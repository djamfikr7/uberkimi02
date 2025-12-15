import 'package:flutter/material.dart';
import 'package:uber_shared/widgets/neomorphic_app_bar.dart';
import 'package:uber_shared/widgets/neomorphic_card.dart';
import 'package:uber_shared/widgets/neomorphic_button.dart';
import 'package:admin_app/theme/app_theme.dart';
import 'package:admin_app/services/api_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  Map<String, dynamic>? _analyticsData;
  bool _isLoading = true;
  String _errorMessage = '';
  String _selectedPeriod = 'week';

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // For now, we'll use mock data since the API doesn't have this endpoint yet
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _analyticsData = {
          'revenue': {
            'daily': [1200, 1500, 1800, 1600, 2100, 2400, 1900],
            'weekly': [8500, 9200, 10500, 9800],
            'monthly': [38000, 42000, 39500, 45000]
          },
          'rides': {
            'daily': [120, 150, 180, 160, 210, 240, 190],
            'weekly': [850, 920, 1050, 980],
            'monthly': [3800, 4200, 3950, 4500]
          },
          'users': {
            'daily': [45, 52, 61, 58, 72, 80, 65],
            'weekly': [320, 360, 410, 380],
            'monthly': [1450, 1620, 1580, 1750]
          }
        };
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Error loading analytics data: ${error.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: NeomorphicAppBar(
        title: const Text('Analytics & Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalyticsData,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report downloaded successfully'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAnalyticsData,
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
                        'System Analytics',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Comprehensive insights into system performance and business metrics',
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text(
                            'Period:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          DropdownButton<String>(
                            value: _selectedPeriod,
                            items: const [
                              DropdownMenuItem(value: 'day', child: Text('Daily')),
                              DropdownMenuItem(value: 'week', child: Text('Weekly')),
                              DropdownMenuItem(value: 'month', child: Text('Monthly')),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedPeriod = value;
                                });
                              }
                            },
                          ),
                          const Spacer(),
                          NeomorphicButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Custom date range feature coming soon'),
                                  backgroundColor: AppTheme.primaryColor,
                                ),
                              );
                            },
                            width: 150,
                            height: 40,
                            child: const Text('Custom Range'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Revenue Chart
              const Text(
                'Revenue Trends',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              
              const SizedBox(height: 16),
              
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_errorMessage.isNotEmpty)
                NeomorphicCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: AppTheme.errorColor),
                    ),
                  ),
                )
              else if (_analyticsData != null)
                ..._buildRevenueCharts()
              else
                NeomorphicCard(
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No analytics data available'),
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // Rides Chart
              const Text(
                'Ride Activity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              
              const SizedBox(height: 16),
              
              if (_analyticsData != null && !_isLoading)
                ..._buildRidesCharts()
              else
                NeomorphicCard(
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No ride data available'),
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // User Growth
              const Text(
                'User Growth',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              
              const SizedBox(height: 16),
              
              if (_analyticsData != null && !_isLoading)
                ..._buildUserGrowthCharts()
              else
                NeomorphicCard(
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No user growth data available'),
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // Key Metrics
              const Text(
                'Key Performance Indicators',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              
              const SizedBox(height: 16),
              
              if (_analyticsData != null && !_isLoading)
                ..._buildKeyMetrics()
              else
                NeomorphicCard(
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No KPI data available'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  List<Widget> _buildRevenueCharts() {
    return [
      NeomorphicCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Revenue Over Time',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: _buildChart(
                  _analyticsData!['revenue'][_selectedPeriod],
                  AppTheme.primaryColor,
                  '\$',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMetricCard(
                    'Total Revenue',
                    '\$${_analyticsData!['revenue'][_selectedPeriod].reduce((a, b) => a + b).toStringAsFixed(2)}',
                    AppTheme.successColor,
                  ),
                  _buildMetricCard(
                    'Avg. Per Day',
                    '\$${(_analyticsData!['revenue'][_selectedPeriod].reduce((a, b) => a + b) / _analyticsData!['revenue'][_selectedPeriod].length).toStringAsFixed(2)}',
                    AppTheme.primaryColor,
                  ),
                  _buildMetricCard(
                    'Growth Rate',
                    '+12.5%',
                    AppTheme.warningColor
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }
  
  List<Widget> _buildRidesCharts() {
    return [
      NeomorphicCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rides Over Time',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: _buildChart(
                  _analyticsData!['rides'][_selectedPeriod],
                  AppTheme.accentColor,
                  '',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMetricCard(
                    'Total Rides',
                    _analyticsData!['rides'][_selectedPeriod].reduce((a, b) => a + b).toString(),
                    AppTheme.successColor,
                  ),
                  _buildMetricCard(
                    'Avg. Per Day',
                    (_analyticsData!['rides'][_selectedPeriod].reduce((a, b) => a + b) / _analyticsData!['rides'][_selectedPeriod].length).toStringAsFixed(1),
                    AppTheme.primaryColor,
                  ),
                  _buildMetricCard(
                    'Completion Rate',
                    '95.2%',
                    AppTheme.warningColor
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }
  
  List<Widget> _buildUserGrowthCharts() {
    return [
      NeomorphicCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Growth',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: _buildChart(
                  _analyticsData!['users'][_selectedPeriod],
                  AppTheme.primaryColor,
                  '',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMetricCard(
                    'Total Users',
                    _analyticsData!['users'][_selectedPeriod].reduce((a, b) => a + b).toString(),
                    AppTheme.successColor,
                  ),
                  _buildMetricCard(
                    'New Users',
                    (_analyticsData!['users'][_selectedPeriod].last - _analyticsData!['users'][_selectedPeriod].first).toString(),
                    AppTheme.primaryColor,
                  ),
                  _buildMetricCard(
                    'Growth Rate',
                    '+8.3%',
                    AppTheme.warningColor
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }
  
  List<Widget> _buildKeyMetrics() {
    return [
      GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildKpiCard(
            'Avg. Ride Distance',
            '4.2 km',
            Icons.directions_car,
            AppTheme.primaryColor
          ),
          _buildKpiCard(
            'Avg. Ride Duration',
            '12.5 min',
            Icons.access_time,
            AppTheme.accentColor
          ),
          _buildKpiCard(
            'Peak Hours',
            '17:00-19:00',
            Icons.schedule,
            AppTheme.primaryColor,
          ),
          _buildKpiCard(
            'Cancellation Rate',
            '2.1%',
            Icons.cancel,
            AppTheme.errorColor,
          ),
        ],
      ),
    ];
  }
  
  Widget _buildChart(List<int> data, Color color, String prefix) {
    if (data.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: AppTheme.textSecondaryColor),
        ),
      );
    }
    
    int maxValue = data.reduce((a, b) => a > b ? a : b);
    
    return CustomPaint(
      painter: ChartPainter(data, color, maxValue),
      size: const Size(double.infinity, 200),
    );
  }
  
  Widget _buildMetricCard(String title, String value, Color color) {
    return NeomorphicCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return NeomorphicCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<int> data;
  final Color color;
  final int maxValue;

  ChartPainter(this.data, this.color, this.maxValue);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    final fillPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    final path = Path();
    final fillPath = Path();
    
    double width = size.width;
    double height = size.height;
    double pointWidth = width / (data.length - 1);
    
    // Draw filled area
    fillPath.moveTo(0, height);
    for (int i = 0; i < data.length; i++) {
      double x = i * pointWidth;
      double y = height - (data[i] / maxValue) * height;
      
      if (i == 0) {
        fillPath.lineTo(x, y);
      } else {
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(width, height);
    fillPath.close();
    
    canvas.drawPath(fillPath, fillPaint);
    
    // Draw line
    for (int i = 0; i < data.length; i++) {
      double x = i * pointWidth;
      double y = height - (data[i] / maxValue) * height;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, paint);
    
    // Draw points
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < data.length; i++) {
      double x = i * pointWidth;
      double y = height - (data[i] / maxValue) * height;
      
      canvas.drawCircle(Offset(x, y), 5, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}