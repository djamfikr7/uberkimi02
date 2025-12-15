import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A neomorphic toggle switch with smooth animation and gradient effects
class NeomorphicToggleSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? activeText;
  final String? inactiveText;
  final double width;
  final double height;

  const NeomorphicToggleSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeText,
    this.inactiveText,
    this.width = 60,
    this.height = 30,
  }) : super(key: key);

  @override
  State<NeomorphicToggleSwitch> createState() => _NeomorphicToggleSwitchState();
}

class _NeomorphicToggleSwitchState extends State<NeomorphicToggleSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant NeomorphicToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
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
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(widget.height / 2),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowDark.withOpacity(0.2),
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
            BoxShadow(
              color: AppTheme.shadowLight.withOpacity(0.2),
              offset: const Offset(-2, -2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Active text
            if (widget.activeText != null)
              Positioned(
                left: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Text(
                    widget.activeText!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ),
              ),
            // Inactive text
            if (widget.inactiveText != null)
              Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Text(
                    widget.inactiveText!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                ),
              ),
            // Thumb
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    _animation.value * (widget.width - widget.height),
                    0,
                  ),
                  child: Container(
                    width: widget.height - 4,
                    height: widget.height - 4,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _animation.value > 0.5
                          ? AppTheme.accentGradient
                          : AppTheme.primaryGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.shadowDark.withOpacity(0.3),
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                        ),
                        BoxShadow(
                          color: AppTheme.shadowLight.withOpacity(0.3),
                          offset: const Offset(-1, -1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}