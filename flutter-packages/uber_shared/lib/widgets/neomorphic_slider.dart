import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A neomorphic slider with gradient track and elevated thumb
class NeomorphicSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int divisions;
  final String? label;

  const NeomorphicSlider({
    Key? key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions = 100,
    this.label,
  }) : super(key: key);

  @override
  State<NeomorphicSlider> createState() => _NeomorphicSliderState();
}

class _NeomorphicSliderState extends State<NeomorphicSlider> {
  double _currentValue = 0.0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant NeomorphicSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() {
        _currentValue = widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
        activeTrackColor: AppTheme.primaryLight,
        inactiveTrackColor: AppTheme.backgroundColor,
        thumbColor: AppTheme.surfaceColor,
        overlayColor: AppTheme.primaryLight.withOpacity(0.2),
        tickMarkShape: const RoundSliderTickMarkShape(),
        activeTickMarkColor: AppTheme.primaryLight,
        inactiveTickMarkColor: AppTheme.neutral,
        valueIndicatorColor: AppTheme.primaryLight,
        valueIndicatorTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Colors.white,
            ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
        child: Slider(
          value: _currentValue,
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          label: widget.label ?? _currentValue.toStringAsFixed(1),
          onChanged: (value) {
            setState(() {
              _currentValue = value;
            });
            widget.onChanged(value);
          },
        ),
      ),
    );
  }
}