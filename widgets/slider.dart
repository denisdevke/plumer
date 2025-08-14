import 'package:flutter/material.dart';

/// A beautiful, customizable slider widget with modern design
/// 
/// Usage:
/// ```dart
/// PlumerSlider(
///   value: _currentValue,
///   onChanged: (value) => setState(() => _currentValue = value),
///   min: 0.0,
///   max: 100.0,
///   label: 'Volume',
/// )
/// ```
class PlumerSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final double thumbRadius;
  final bool showValue;
  final String Function(double)? valueFormatter;
  final int? divisions;

  const PlumerSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.thumbRadius = 12.0,
    this.showValue = true,
    this.valueFormatter,
    this.divisions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = activeColor ?? theme.colorScheme.primary;
    final backgroundColor = inactiveColor ?? theme.colorScheme.outline.withOpacity(0.3);
    final thumb = thumbColor ?? primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (showValue)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    valueFormatter?.call(value) ?? value.toStringAsFixed(1),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6.0,
            activeTrackColor: primaryColor,
            inactiveTrackColor: backgroundColor,
            thumbColor: thumb,
            overlayColor: primaryColor.withOpacity(0.2),
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: thumbRadius,
              elevation: 2.0,
            ),
            overlayShape: RoundSliderOverlayShape(
              overlayRadius: thumbRadius + 8,
            ),
            trackShape: const RoundedRectSliderTrackShape(),
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: primaryColor,
            valueIndicatorTextStyle: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            label: valueFormatter?.call(value) ?? value.toStringAsFixed(1),
          ),
        ),
      ],
    );
  }
}

/// A range slider widget with modern styling
/// 
/// Usage:
/// ```dart
/// PlumerRangeSlider(
///   values: RangeValues(20, 80),
///   onChanged: (values) => setState(() => _rangeValues = values),
///   min: 0.0,
///   max: 100.0,
///   label: 'Price Range',
/// )
/// ```
class PlumerRangeSlider extends StatelessWidget {
  final RangeValues values;
  final ValueChanged<RangeValues>? onChanged;
  final double min;
  final double max;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final double thumbRadius;
  final bool showValues;
  final String Function(double)? valueFormatter;
  final int? divisions;

  const PlumerRangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.label,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.thumbRadius = 12.0,
    this.showValues = true,
    this.valueFormatter,
    this.divisions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = activeColor ?? theme.colorScheme.primary;
    final backgroundColor = inactiveColor ?? theme.colorScheme.outline.withOpacity(0.3);
    final thumb = thumbColor ?? primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (showValues)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${valueFormatter?.call(values.start) ?? values.start.toStringAsFixed(1)} - ${valueFormatter?.call(values.end) ?? values.end.toStringAsFixed(1)}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6.0,
            activeTrackColor: primaryColor,
            inactiveTrackColor: backgroundColor,
            thumbColor: thumb,
            overlayColor: primaryColor.withOpacity(0.2),
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: thumbRadius,
              elevation: 2.0,
            ),
            overlayShape: RoundSliderOverlayShape(
              overlayRadius: thumbRadius + 8,
            ),
            trackShape: const RoundedRectSliderTrackShape(),
            rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: primaryColor,
            valueIndicatorTextStyle: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          child: RangeSlider(
            values: RangeValues(
              values.start.clamp(min, max),
              values.end.clamp(min, max),
            ),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            labels: RangeLabels(
              valueFormatter?.call(values.start) ?? values.start.toStringAsFixed(1),
              valueFormatter?.call(values.end) ?? values.end.toStringAsFixed(1),
            ),
          ),
        ),
      ],
    );
  }
}

/// A discrete slider with step indicators
/// 
/// Usage:
/// ```dart
/// PlumerStepSlider(
///   value: _currentStep,
///   onChanged: (value) => setState(() => _currentStep = value),
///   steps: ['Small', 'Medium', 'Large', 'XLarge'],
///   label: 'Size',
/// )
/// ```
class PlumerStepSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int>? onChanged;
  final List<String> steps;
  final String? label;
  final Color? activeColor;
  final Color? inactiveColor;

  const PlumerStepSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.steps,
    this.label,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = activeColor ?? theme.colorScheme.primary;
    final backgroundColor = inactiveColor ?? theme.colorScheme.outline.withOpacity(0.3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  steps[value.clamp(0, steps.length - 1)],
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6.0,
            activeTrackColor: primaryColor,
            inactiveTrackColor: backgroundColor,
            thumbColor: primaryColor,
            overlayColor: primaryColor.withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 12.0,
              elevation: 2.0,
            ),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 20,
            ),
            tickMarkShape: const RoundSliderTickMarkShape(),
            activeTickMarkColor: primaryColor,
            inactiveTickMarkColor: backgroundColor,
          ),
          child: Slider(
            value: value.toDouble().clamp(0, steps.length - 1),
            min: 0,
            max: (steps.length - 1).toDouble(),
            divisions: steps.length - 1,
            onChanged: onChanged != null 
              ? (val) => onChanged!(val.round())
              : null,
          ),
        ),
        // Step labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isActive = index == value;
              
              return Text(
                step,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isActive ? primaryColor : theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}