import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A neomorphic button widget with shadow effects, gradient backgrounds,
/// and smooth hover animations as specified in the design requirements.
class NeomorphicButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? pressedColor;
  final Duration animationDuration;

  const NeomorphicButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.width = double.infinity,
    this.height = 50,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.isEnabled = true,
    this.backgroundColor,
    this.pressedColor,
    this.animationDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  State<NeomorphicButton> createState() => _NeomorphicButtonState();
}

class _NeomorphicButtonState extends State<NeomorphicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
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
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
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
                // Execute the callback after animation completes
                Future.delayed(widget.animationDuration, () {
                  if (mounted) widget.onPressed();
                });
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
          animation: _controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Glow effect when hovered
                if (_isHovered && !_isPressed)
                  Container(
                    width: widget.width + 10 * _glowAnimation.value,
                    height: widget.height + 10 * _glowAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.primaryLight.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                // Main button
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: widget.width,
                    height: widget.height,
                    decoration: BoxDecoration(
                      gradient: _isPressed
                          ? (widget.pressedColor != null
                              ? LinearGradient(colors: [widget.pressedColor!, widget.pressedColor!])
                              : AppTheme.primaryGradient)
                          : (widget.backgroundColor != null
                              ? LinearGradient(colors: [widget.backgroundColor!, widget.backgroundColor!])
                              : AppTheme.accentGradient),
                      borderRadius: widget.borderRadius,
                      boxShadow: [
                        BoxShadow(
                          color: _isPressed
                              ? AppTheme.shadowDark.withOpacity(0.1)
                              : AppTheme.shadowDark.withOpacity(0.3),
                          offset: _isPressed ? const Offset(2, 2) : const Offset(4, 4),
                          blurRadius: _isPressed ? 4 : 8,
                        ),
                        BoxShadow(
                          color: _isPressed
                              ? AppTheme.shadowLight.withOpacity(0.1)
                              : AppTheme.shadowLight.withOpacity(0.3),
                          offset: _isPressed ? const Offset(-2, -2) : const Offset(-4, -4),
                          blurRadius: _isPressed ? 4 : 8,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.isEnabled ? () {} : null, // Handled by GestureDetector
                        borderRadius: widget.borderRadius,
                        child: Padding(
                          padding: widget.padding,
                          child: Center(
                            child: DefaultTextStyle(
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                              child: widget.child,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}