import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// An animated map marker with pulsing effects and smooth transitions
class AnimatedMapMarker extends StatefulWidget {
  final double size;
  final Color color;
  final String label;
  final bool isPulsing;
  final Duration animationDuration;

  const AnimatedMapMarker({
    Key? key,
    this.size = 40.0,
    this.color = AppTheme.primaryLight,
    this.label = '',
    this.isPulsing = true,
    this.animationDuration = const Duration(milliseconds: 1000),
  }) : super(key: key);

  @override
  State<AnimatedMapMarker> createState() => _AnimatedMapMarkerState();
}

class _AnimatedMapMarkerState extends State<AnimatedMapMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -5.0), weight: 25),
      TweenSequenceItem(tween: Tween<double>(begin: -5.0, end: 0.0), weight: 25),
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: -3.0), weight: 25),
      TweenSequenceItem(tween: Tween<double>(begin: -3.0, end: 0.0), weight: 25),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isPulsing) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedMapMarker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPulsing != widget.isPulsing) {
      if (widget.isPulsing) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulse effect
              if (widget.isPulsing)
                Container(
                  width: widget.size * _pulseAnimation.value,
                  height: widget.size * _pulseAnimation.value,
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.3 * (1 - (_pulseAnimation.value - 1) * 2)),
                    shape: BoxShape.circle,
                  ),
                ),
              // Main marker
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: widget.label.isNotEmpty
                      ? Text(
                          widget.label,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: widget.size * 0.4,
                          ),
                        )
                      : Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: widget.size * 0.7,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}