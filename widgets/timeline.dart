import 'package:flutter/material.dart';

/// A modern timeline widget for displaying processes and activity flows
/// 
/// Usage:
/// ```dart
/// PlumerTimeline(
///   items: [
///     PlumerTimelineItem(
///       title: 'Order Placed',
///       description: 'Your order has been confirmed',
///       status: PlumerTimelineStatus.completed,
///       timestamp: DateTime.now(),
///     ),
///     PlumerTimelineItem(
///       title: 'Processing',
///       description: 'We are preparing your order',
///       status: PlumerTimelineStatus.current,
///     ),
///   ],
/// )
/// ```
class PlumerTimeline extends StatelessWidget {
  final List<PlumerTimelineItem> items;
  final PlumerTimelineStyle style;
  final Color? lineColor;
  final Color? completedColor;
  final Color? currentColor;
  final Color? pendingColor;
  final double lineWidth;
  final double indicatorSize;
  final EdgeInsetsGeometry? padding;
  final bool showTimestamps;

  const PlumerTimeline({
    super.key,
    required this.items,
    this.style = PlumerTimelineStyle.vertical,
    this.lineColor,
    this.completedColor,
    this.currentColor,
    this.pendingColor,
    this.lineWidth = 2.0,
    this.indicatorSize = 20.0,
    this.padding,
    this.showTimestamps = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    switch (style) {
      case PlumerTimelineStyle.vertical:
        return _buildVerticalTimeline(theme);
      case PlumerTimelineStyle.horizontal:
        return _buildHorizontalTimeline(theme);
      case PlumerTimelineStyle.minimal:
        return _buildMinimalTimeline(theme);
    }
  }

  Widget _buildVerticalTimeline(ThemeData theme) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;

          return _buildVerticalTimelineItem(theme, item, isLast);
        }).toList(),
      ),
    );
  }

  Widget _buildHorizontalTimeline(ThemeData theme) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == items.length - 1;

            return _buildHorizontalTimelineItem(theme, item, isLast);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMinimalTimeline(ThemeData theme) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return _buildMinimalTimelineItem(theme, item, index);
        }).toList(),
      ),
    );
  }

  Widget _buildVerticalTimelineItem(ThemeData theme, PlumerTimelineItem item, bool isLast) {
    final colors = _getStatusColors(theme, item.status);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator and line
        Column(
          children: [
            _buildIndicator(theme, item, colors),
            if (!isLast)
              Container(
                width: lineWidth,
                height: 60,
                color: lineColor ?? theme.colorScheme.outline.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.primary,
                      ),
                    ),
                    if (item.timestamp != null && showTimestamps)
                      Text(
                        _formatTimestamp(item.timestamp!),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                  ],
                ),
                if (item.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ],
                if (item.action != null) ...[
                  const SizedBox(height: 8),
                  item.action!,
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalTimelineItem(ThemeData theme, PlumerTimelineItem item, bool isLast) {
    final colors = _getStatusColors(theme, item.status);
    
    return Row(
      children: [
        Column(
          children: [
            _buildIndicator(theme, item, colors),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(maxWidth: 120),
              child: Column(
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.description!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (!isLast) ...[
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: lineWidth,
            color: lineColor ?? theme.colorScheme.outline.withOpacity(0.3),
          ),
          const SizedBox(width: 8),
        ],
      ],
    );
  }

  Widget _buildMinimalTimelineItem(ThemeData theme, PlumerTimelineItem item, int index) {
    final colors = _getStatusColors(theme, item.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: item.icon != null
                  ? Icon(
                      item.icon,
                      color: theme.colorScheme.onPrimary,
                      size: 18,
                    )
                  : Text(
                      '${index + 1}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.primary,
                      ),
                    ),
                    if (item.timestamp != null && showTimestamps)
                      Text(
                        _formatTimestamp(item.timestamp!),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                  ],
                ),
                if (item.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.description!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ],
                if (item.action != null) ...[
                  const SizedBox(height: 8),
                  item.action!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(ThemeData theme, PlumerTimelineItem item, _TimelineColors colors) {
    switch (item.status) {
      case PlumerTimelineStatus.completed:
        return Container(
          width: indicatorSize,
          height: indicatorSize,
          decoration: BoxDecoration(
            color: colors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            item.icon ?? Icons.check,
            color: theme.colorScheme.onPrimary,
            size: indicatorSize * 0.6,
          ),
        );
      case PlumerTimelineStatus.current:
        return Container(
          width: indicatorSize,
          height: indicatorSize,
          decoration: BoxDecoration(
            color: colors.primary,
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.primary.withOpacity(0.3),
              width: 3,
            ),
          ),
          child: item.icon != null
              ? Icon(
                  item.icon,
                  color: theme.colorScheme.onPrimary,
                  size: indicatorSize * 0.5,
                )
              : null,
        );
      case PlumerTimelineStatus.pending:
        return Container(
          width: indicatorSize,
          height: indicatorSize,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.primary,
              width: 2,
            ),
          ),
          child: item.icon != null
              ? Icon(
                  item.icon,
                  color: colors.primary,
                  size: indicatorSize * 0.5,
                )
              : null,
        );
      case PlumerTimelineStatus.error:
        return Container(
          width: indicatorSize,
          height: indicatorSize,
          decoration: BoxDecoration(
            color: colors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            item.icon ?? Icons.close,
            color: theme.colorScheme.onError,
            size: indicatorSize * 0.6,
          ),
        );
    }
  }

  _TimelineColors _getStatusColors(ThemeData theme, PlumerTimelineStatus status) {
    switch (status) {
      case PlumerTimelineStatus.completed:
        return _TimelineColors(
          primary: completedColor ?? Colors.green,
          background: (completedColor ?? Colors.green).withOpacity(0.1),
        );
      case PlumerTimelineStatus.current:
        return _TimelineColors(
          primary: currentColor ?? theme.colorScheme.primary,
          background: (currentColor ?? theme.colorScheme.primary).withOpacity(0.1),
        );
      case PlumerTimelineStatus.pending:
        return _TimelineColors(
          primary: pendingColor ?? theme.colorScheme.outline,
          background: (pendingColor ?? theme.colorScheme.outline).withOpacity(0.1),
        );
      case PlumerTimelineStatus.error:
        return _TimelineColors(
          primary: theme.colorScheme.error,
          background: theme.colorScheme.error.withOpacity(0.1),
        );
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

/// Configuration for timeline items
class PlumerTimelineItem {
  final String title;
  final String? description;
  final PlumerTimelineStatus status;
  final IconData? icon;
  final DateTime? timestamp;
  final Widget? action;

  const PlumerTimelineItem({
    required this.title,
    this.description,
    required this.status,
    this.icon,
    this.timestamp,
    this.action,
  });
}

/// Timeline item statuses
enum PlumerTimelineStatus {
  completed,
  current,
  pending,
  error,
}

/// Timeline display styles
enum PlumerTimelineStyle {
  vertical,
  horizontal,
  minimal,
}

/// Helper class for timeline colors
class _TimelineColors {
  final Color primary;
  final Color background;

  _TimelineColors({
    required this.primary,
    required this.background,
  });
}

/// A progress stepper widget for multi-step processes
/// 
/// Usage:
/// ```dart
/// PlumerStepper(
///   currentStep: _currentStep,
///   steps: [
///     PlumerStepperItem(
///       title: 'Personal Info',
///       content: PersonalInfoForm(),
///     ),
///     PlumerStepperItem(
///       title: 'Payment',
///       content: PaymentForm(),
///     ),
///   ],
///   onStepTapped: (step) => setState(() => _currentStep = step),
/// )
/// ```
class PlumerStepper extends StatelessWidget {
  final int currentStep;
  final List<PlumerStepperItem> steps;
  final ValueChanged<int>? onStepTapped;
  final PlumerStepperStyle style;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showStepNumbers;
  final EdgeInsetsGeometry? padding;

  const PlumerStepper({
    super.key,
    required this.currentStep,
    required this.steps,
    this.onStepTapped,
    this.style = PlumerStepperStyle.horizontal,
    this.activeColor,
    this.inactiveColor,
    this.showStepNumbers = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeCol = activeColor ?? theme.colorScheme.primary;
    final inactiveCol = inactiveColor ?? theme.colorScheme.outline;

    return Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStepIndicators(theme, activeCol, inactiveCol),
          const SizedBox(height: 24),
          if (currentStep < steps.length) _buildStepContent(),
        ],
      ),
    );
  }

  Widget _buildStepIndicators(ThemeData theme, Color activeColor, Color inactiveColor) {
    return Row(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isActive = index <= currentStep;
        final isCurrent = index == currentStep;
        final isLast = index == steps.length - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onStepTapped != null ? () => onStepTapped!(index) : null,
                  child: Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isActive ? activeColor : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isActive ? activeColor : inactiveColor,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: showStepNumbers
                              ? Text(
                                  '${index + 1}',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: isActive 
                                        ? theme.colorScheme.onPrimary
                                        : inactiveColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : step.icon != null
                                  ? Icon(
                                      step.icon,
                                      color: isActive 
                                          ? theme.colorScheme.onPrimary
                                          : inactiveColor,
                                      size: 18,
                                    )
                                  : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        step.title,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isCurrent ? activeColor : inactiveColor,
                          fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  height: 2,
                  width: 24,
                  color: isActive ? activeColor : inactiveColor,
                  margin: const EdgeInsets.only(bottom: 24),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStepContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(currentStep),
        child: steps[currentStep].content,
      ),
    );
  }
}

/// Configuration for stepper items
class PlumerStepperItem {
  final String title;
  final Widget content;
  final IconData? icon;

  const PlumerStepperItem({
    required this.title,
    required this.content,
    this.icon,
  });
}

/// Stepper display styles
enum PlumerStepperStyle {
  horizontal,
  vertical,
}