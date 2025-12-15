import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A neomorphic text field widget with inset appearance, subtle borders,
/// and focus state highlighting as specified in the design requirements.
class NeomorphicTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? minLines;
  final Color? focusColor;
  final Duration animationDuration;
  final bool enableFloatingLabel;

  const NeomorphicTextField({
    Key? key,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
    this.minLines,
    this.focusColor,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enableFloatingLabel = false,
  }) : super(key: key);

  @override
  State<NeomorphicTextField> createState() => _NeomorphicTextFieldState();
}

class _NeomorphicTextFieldState extends State<NeomorphicTextField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late AnimationController _controller;
  late Animation<double> _focusAnimation;
  late Animation<double> _labelAnimation;
  bool _isFocused = false;
  bool _hasContent = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _focusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _labelAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
        if (_isFocused) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
        _hasContent = widget.controller?.text?.isNotEmpty ?? false;
      });
    });
    
    // Check initial content
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _hasContent = widget.controller?.text?.isNotEmpty ?? false;
          if (_hasContent) {
            _controller.value = 1.0;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(() {});
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _isFocused
                    ? (widget.focusColor ?? AppTheme.primaryLight).withOpacity(0.3 * _focusAnimation.value)
                    : AppTheme.shadowDark.withOpacity(0.2 * (1 - _focusAnimation.value)),
                offset: Offset.lerp(
                  const Offset(2, 2),
                  const Offset(0, 0),
                  _focusAnimation.value,
                )!,
                blurRadius: 4 + (4 * _focusAnimation.value),
                spreadRadius: _focusAnimation.value,
              ),
              if (!_isFocused)
                BoxShadow(
                  color: AppTheme.shadowLight.withOpacity(0.2 * (1 - _focusAnimation.value)),
                  offset: const Offset(-2, -2),
                  blurRadius: 4,
                ),
            ],
          ),
          child: Stack(
            children: [
              // Floating label
              if (widget.enableFloatingLabel && (widget.hintText != null))
                Positioned(
                  top: 8 - (8 * _labelAnimation.value),
                  left: 16,
                  child: Transform.scale(
                    scale: _labelAnimation.value,
                    child: Text(
                      widget.hintText!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Color.lerp(
                          AppTheme.textSecondary,
                          widget.focusColor ?? AppTheme.primaryLight,
                          _focusAnimation.value,
                        ),
                      ),
                    ),
                  ),
                ),
              // Text field
              TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                keyboardType: widget.keyboardType,
                obscureText: widget.obscureText,
                onChanged: (value) {
                  widget.onChanged?.call(value);
                  setState(() {
                    _hasContent = value.isNotEmpty;
                  });
                },
                validator: widget.validator,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: (!widget.enableFloatingLabel || (_isFocused || _hasContent)) ? widget.hintText : null,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Color.lerp(
                      AppTheme.textSecondary,
                      widget.focusColor ?? AppTheme.primaryLight,
                      _focusAnimation.value,
                    ),
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(
                          widget.prefixIcon,
                          color: Color.lerp(
                            AppTheme.textSecondary,
                            widget.focusColor ?? AppTheme.primaryLight,
                            _focusAnimation.value,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}