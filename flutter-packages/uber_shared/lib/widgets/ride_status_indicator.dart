import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A widget that displays ride status with animated transitions and visual indicators
class RideStatusIndicator extends StatefulWidget {
  final String status;
  final double size;
  final Duration animationDuration;

  const RideStatusIndicator({
    Key? key,
    required this.status,
    this.size = 24.0,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<RideStatusIndicator> createState() => _RideStatusIndicatorState();
}

class _RideStatusIndicatorState extends State<RideStatusIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  String? _previousStatus;

  @override
  void initState() {
    super.initState();
    _previousStatus = widget.status;
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _setupColorAnimation();
  }

  @override
  void didUpdateWidget(covariant RideStatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) {
      _previousStatus = oldWidget.status;
      _setupColorAnimation();
      _controller.reset();
      _controller.forward();
    }
  }

  void _setupColorAnimation() {
    final oldColor = _getStatusColor(_previousStatus ?? '');
    final newColor = _getStatusColor(widget.status);
    _colorAnimation = ColorTween(begin: oldColor, end: newColor).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'requested':
        return AppTheme.primaryLight;
      case 'accepted':
        return Colors.blue;
      case 'arrived':
        return Colors.purple;
      case 'in_progress':
        return Colors.green;
      case 'completed':
        return AppTheme.successColor;
      case 'cancelled':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'requested':
        return Icons.search;
      case 'accepted':
        return Icons.check_circle;
      case 'arrived':
        return Icons.directions_car;
      case 'in_progress':
        return Icons.play_arrow;
      case 'completed':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'requested':
        return 'Finding Driver';
      case 'accepted':
        return 'Driver Assigned';
      case 'arrived':
        return 'Driver Arrived';
      case 'in_progress':
        return 'On the Way';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: _colorAnimation.value,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _colorAnimation.value!.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  _getStatusIcon(widget.status),
                  color: Colors.white,
                  size: widget.size * 0.6,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getStatusText(widget.status),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _colorAnimation.value,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        );
      },
    );
  }
}