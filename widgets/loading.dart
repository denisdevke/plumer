import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A modern loading spinner with customizable styling
/// 
/// Usage:
/// ```dart
/// PlumerSpinner(
///   size: PlumerSpinnerSize.large,
///   color: Colors.blue,
///   strokeWidth: 3.0,
/// )
/// ```
class PlumerSpinner extends StatefulWidget {
  final PlumerSpinnerSize size;
  final Color? color;
  final double? strokeWidth;
  final PlumerSpinnerStyle style;

  const PlumerSpinner({
    super.key,
    this.size = PlumerSpinnerSize.medium,
    this.color,
    this.strokeWidth,
    this.style = PlumerSpinnerStyle.circular,
  });

  @override
  State<PlumerSpinner> createState() => _PlumerSpinnerState();
}

class _PlumerSpinnerState extends State<PlumerSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spinnerSize = _getSpinnerSize();
    final spinnerColor = widget.color ?? theme.colorScheme.primary;

    switch (widget.style) {
      case PlumerSpinnerStyle.circular:
        return SizedBox(
          width: spinnerSize,
          height: spinnerSize,
          child: CircularProgressIndicator(
            strokeWidth: widget.strokeWidth ?? _getDefaultStrokeWidth(),
            valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
          ),
        );

      case PlumerSpinnerStyle.dots:
        return SizedBox(
          width: spinnerSize,
          height: spinnerSize * 0.3,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  final delay = index * 0.2;
                  final animation = Tween<double>(
                    begin: 0.3,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      delay,
                      delay + 0.4,
                      curve: Curves.easeInOut,
                    ),
                  ));

                  return AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Container(
                        width: spinnerSize * 0.15,
                        height: spinnerSize * 0.15,
                        margin: EdgeInsets.symmetric(
                          horizontal: spinnerSize * 0.05,
                        ),
                        decoration: BoxDecoration(
                          color: spinnerColor.withOpacity(animation.value),
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  );
                }),
              );
            },
          ),
        );

      case PlumerSpinnerStyle.pulse:
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final scale = Tween<double>(
              begin: 0.8,
              end: 1.2,
            ).animate(CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeInOut,
            ));

            return Transform.scale(
              scale: scale.value,
              child: Container(
                width: spinnerSize,
                height: spinnerSize,
                decoration: BoxDecoration(
                  color: spinnerColor.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
    }
  }

  double _getSpinnerSize() {
    switch (widget.size) {
      case PlumerSpinnerSize.small:
        return 20.0;
      case PlumerSpinnerSize.medium:
        return 32.0;
      case PlumerSpinnerSize.large:
        return 48.0;
    }
  }

  double _getDefaultStrokeWidth() {
    switch (widget.size) {
      case PlumerSpinnerSize.small:
        return 2.0;
      case PlumerSpinnerSize.medium:
        return 3.0;
      case PlumerSpinnerSize.large:
        return 4.0;
    }
  }
}

enum PlumerSpinnerSize {
  small,
  medium,
  large,
}

enum PlumerSpinnerStyle {
  circular,
  dots,
  pulse,
}

/// A modern progress bar with customizable styling
/// 
/// Usage:
/// ```dart
/// PlumerProgressBar(
///   value: 0.7,
///   label: 'Upload Progress',
///   showPercentage: true,
/// )
/// ```
class PlumerProgressBar extends StatelessWidget {
  final double? value; // null for indeterminate
  final String? label;
  final bool showPercentage;
  final Color? backgroundColor;
  final Color? progressColor;
  final double height;
  final BorderRadius? borderRadius;
  final PlumerProgressBarVariant variant;

  const PlumerProgressBar({
    super.key,
    this.value,
    this.label,
    this.showPercentage = false,
    this.backgroundColor,
    this.progressColor,
    this.height = 8.0,
    this.borderRadius,
    this.variant = PlumerProgressBarVariant.linear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null || showPercentage) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (showPercentage && value != null)
                Text(
                  '${(value! * 100).round()}%',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: progressColor ?? theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        _buildProgressBar(theme),
      ],
    );
  }

  Widget _buildProgressBar(ThemeData theme) {
    switch (variant) {
      case PlumerProgressBarVariant.linear:
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.colorScheme.outline.withOpacity(0.2),
            borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
          ),
          child: ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                progressColor ?? theme.colorScheme.primary,
              ),
            ),
          ),
        );

      case PlumerProgressBarVariant.stepped:
        return _buildSteppedProgress(theme);
    }
  }

  Widget _buildSteppedProgress(ThemeData theme) {
    const stepCount = 5;
    final filledSteps = value != null ? (value! * stepCount).round() : 0;

    return Row(
      children: List.generate(stepCount, (index) {
        final isFilled = index < filledSteps;
        
        return Expanded(
          child: Container(
            height: height,
            margin: EdgeInsets.only(right: index < stepCount - 1 ? 4 : 0),
            decoration: BoxDecoration(
              color: isFilled
                  ? (progressColor ?? theme.colorScheme.primary)
                  : (backgroundColor ?? theme.colorScheme.outline.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

enum PlumerProgressBarVariant {
  linear,
  stepped,
}

/// A circular progress indicator with customizable styling
/// 
/// Usage:
/// ```dart
/// PlumerCircularProgress(
///   value: 0.75,
///   size: 100,
///   showPercentage: true,
///   child: Icon(Icons.check),
/// )
/// ```
class PlumerCircularProgress extends StatelessWidget {
  final double? value; // null for indeterminate
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool showPercentage;
  final Widget? child;
  final String? label;

  const PlumerCircularProgress({
    super.key,
    this.value,
    this.size = 80.0,
    this.strokeWidth = 6.0,
    this.backgroundColor,
    this.progressColor,
    this.showPercentage = false,
    this.child,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: strokeWidth,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    backgroundColor ?? theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
              ),
              // Progress circle
              Container(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: strokeWidth,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressColor ?? theme.colorScheme.primary,
                  ),
                ),
              ),
              // Center content
              if (child != null)
                child!
              else if (showPercentage && value != null)
                Text(
                  '${(value! * 100).round()}%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: progressColor ?? theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 8),
          Text(
            label!,
            style: theme.textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// A skeleton loading placeholder widget
/// 
/// Usage:
/// ```dart
/// PlumerSkeleton(
///   width: 200,
///   height: 20,
///   borderRadius: BorderRadius.circular(4),
/// )
/// ```
class PlumerSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const PlumerSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<PlumerSkeleton> createState() => _PlumerSkeletonState();
}

class _PlumerSkeletonState extends State<PlumerSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final baseColor = widget.baseColor ??
        (isDark ? Colors.grey[800]! : Colors.grey[300]!);
    final highlightColor = widget.highlightColor ??
        (isDark ? Colors.grey[700]! : Colors.grey[100]!);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height ?? 16,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                math.max(0.0, _animation.value - 0.3),
                _animation.value,
                math.min(1.0, _animation.value + 0.3),
              ],
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A loading overlay that can be placed over other widgets
/// 
/// Usage:
/// ```dart
/// PlumerLoadingOverlay(
///   isLoading: isLoading,
///   child: YourContentWidget(),
///   message: 'Loading data...',
/// )
/// ```
class PlumerLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final PlumerSpinnerStyle spinnerStyle;
  final Color? overlayColor;
  final Color? spinnerColor;

  const PlumerLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.spinnerStyle = PlumerSpinnerStyle.circular,
    this.overlayColor,
    this.spinnerColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: overlayColor ?? Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PlumerSpinner(
                      style: spinnerStyle,
                      color: spinnerColor,
                      size: PlumerSpinnerSize.large,
                    ),
                    if (message != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        message!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// A shimmer loading effect for list items
/// 
/// Usage:
/// ```dart
/// PlumerShimmerList(
///   itemCount: 5,
///   itemHeight: 80,
///   itemBuilder: (context, index) => ListTile(
///     leading: PlumerSkeleton(width: 40, height: 40),
///     title: PlumerSkeleton(width: double.infinity, height: 16),
///     subtitle: PlumerSkeleton(width: 200, height: 12),
///   ),
/// )
/// ```
class PlumerShimmerList extends StatelessWidget {
  final int itemCount;
  final double? itemHeight;
  final Widget Function(BuildContext, int)? itemBuilder;
  final EdgeInsetsGeometry? padding;

  const PlumerShimmerList({
    super.key,
    this.itemCount = 5,
    this.itemHeight,
    this.itemBuilder,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final item = itemBuilder?.call(context, index) ?? _defaultShimmerItem();
        
        return Container(
          height: itemHeight,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: item,
        );
      },
    );
  }

  Widget _defaultShimmerItem() {
    return ListTile(
      leading: const PlumerSkeleton(
        width: 40,
        height: 40,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      title: const PlumerSkeleton(
        width: double.infinity,
        height: 16,
      ),
      subtitle: const PlumerSkeleton(
        width: 200,
        height: 12,
      ),
    );
  }
}