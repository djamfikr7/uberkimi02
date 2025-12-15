import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A neomorphic card widget with elevated appearance, soft shadows,
/// and rounded corners as specified in the design requirements.
class NeomorphicCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BorderRadius borderRadius;
  final Color? color;
  final Duration animationDuration;
  final bool enableHoverEffect;

  const NeomorphicCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(8),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.color,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enableHoverEffect = true,
  }) : super(key: key);

  @override
  State<NeomorphicCard> createState() => _NeomorphicCardState();
}

class _NeomorphicCardState extends State<NeomorphicCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _elevationAnimation;
  late Animation<double> _shadowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _elevationAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _shadowAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: widget.enableHoverEffect
          ? (_) {
              setState(() => _isHovered = true);
              _controller.forward();
            }
          : null,
      onExit: widget.enableHoverEffect
          ? (_) {
              setState(() => _isHovered = false);
              _controller.reverse();
            }
          : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _elevationAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              margin: widget.margin,
              decoration: BoxDecoration(
                color: widget.color ?? AppTheme.surfaceColor,
                borderRadius: widget.borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowDark.withOpacity(0.2 * _shadowAnimation.value),
                    offset: Offset(6 * _shadowAnimation.value, 6 * _shadowAnimation.value),
                    blurRadius: 12 * _shadowAnimation.value,
                  ),
                  BoxShadow(
                    color: AppTheme.shadowLight.withOpacity(0.2 * _shadowAnimation.value),
                    offset: Offset(-6 * _shadowAnimation.value, -6 * _shadowAnimation.value),
                    blurRadius: 12 * _shadowAnimation.value,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: widget.borderRadius,
                child: Padding(
                  padding: widget.padding,
                  child: widget.child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}