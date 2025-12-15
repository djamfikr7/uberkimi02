import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A neomorphic progress indicator with animated gradient fill
/// and smooth transition effects as specified in the design requirements.
class NeomorphicProgressIndicator extends StatelessWidget {
  final double value;
  final double height;
  final double borderRadius;
  final Duration animationDuration;

  const NeomorphicProgressIndicator({
    Key? key,
    required this.value,
    this.height = 8,
    this.borderRadius = 12,
    this.animationDuration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: AnimatedContainer(
          duration: animationDuration,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: AppTheme.accentGradient,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Background
                  Container(
                    width: constraints.maxWidth,
                    height: height,
                    color: AppTheme.backgroundColor,
                  ),
                  // Progress fill
                  AnimatedContainer(
                    duration: animationDuration,
                    width: constraints.maxWidth * value,
                    height: height,
                    decoration: BoxDecoration(
                      gradient: AppTheme.accentGradient,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}