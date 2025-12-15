import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A neomorphic floating action button with elevated appearance and smooth animations
class NeomorphicFab extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double size;
  final Color? backgroundColor;
  final bool isEnabled;

  const NeomorphicFab({
    Key? key,
    required this.onPressed,
    required this.child,
    this.size = 56,
    this.backgroundColor,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<NeomorphicFab> createState() => _NeomorphicFabState();
}

class _NeomorphicFabState extends State<NeomorphicFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isEnabled
          ? (_) {
              setState(() {
                _isPressed = true;
              });
              _controller.forward();
            }
          : null,
      onTapUp: widget.isEnabled
          ? (_) {
              setState(() {
                _isPressed = false;
              });
              _controller.reverse();
            }
          : null,
      onTapCancel: widget.isEnabled
          ? () {
              setState(() {
                _isPressed = false;
              });
              _controller.reverse();
            }
          : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.backgroundColor ?? AppTheme.surfaceColor,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowDark.withOpacity(0.3),
                    offset: const Offset(4, 4),
                    blurRadius: 8,
                  ),
                  BoxShadow(
                    color: AppTheme.shadowLight.withOpacity(0.3),
                    offset: const Offset(-4, -4),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.isEnabled ? widget.onPressed : null,
                  borderRadius: BorderRadius.circular(widget.size / 2),
                  child: Center(
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}