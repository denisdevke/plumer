import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A circular progress chart with customizable styling and animations
/// 
/// Usage:
/// ```dart
/// PlumerProgressRing(
///   progress: 0.7,
///   size: 120,
///   strokeWidth: 12,
///   backgroundColor: Colors.grey[300],
///   progressColor: Colors.blue,
///   showPercentage: true,
/// )
/// ```
class PlumerProgressRing extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? progressColor;
  final bool showPercentage;
  final Widget? centerWidget;
  final String? label;
  final TextStyle? labelStyle;
  final bool animated;
  final Duration animationDuration;
  final List<Color>? gradientColors;

  const PlumerProgressRing({
    super.key,
    required this.progress,
    this.size = 100.0,
    this.strokeWidth = 8.0,
    this.backgroundColor,
    this.progressColor,
    this.showPercentage = true,
    this.centerWidget,
    this.label,
    this.labelStyle,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.gradientColors,
  });

  @override
  State<PlumerProgressRing> createState() => _PlumerProgressRingState();
}

class _PlumerProgressRingState extends State<PlumerProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.animated) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(PlumerProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      _animationController.reset();
      if (widget.animated) {
        _animationController.forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: widget.animated ? _animation : AlwaysStoppedAnimation(widget.progress),
            builder: (context, child) {
              final currentProgress = widget.animated ? _animation.value : widget.progress;
              
              return Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _ProgressRingPainter(
                      progress: currentProgress,
                      strokeWidth: widget.strokeWidth,
                      backgroundColor: widget.backgroundColor ?? theme.colorScheme.outline.withOpacity(0.2),
                      progressColor: widget.progressColor ?? theme.colorScheme.primary,
                      gradientColors: widget.gradientColors,
                    ),
                  ),
                  if (widget.centerWidget != null)
                    widget.centerWidget!
                  else if (widget.showPercentage)
                    Text(
                      '${(currentProgress * 100).round()}%',
                      style: widget.labelStyle ?? theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: widget.progressColor ?? theme.colorScheme.primary,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        if (widget.label != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.label!,
            style: widget.labelStyle ?? Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Custom painter for progress ring
class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;
  final List<Color>? gradientColors;

  _ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
    this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (gradientColors != null && gradientColors!.length > 1) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      progressPaint.shader = SweepGradient(
        colors: gradientColors!,
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + (2 * math.pi * progress),
      ).createShader(rect);
    } else {
      progressPaint.color = progressColor;
    }

    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor;
  }
}

/// A modern bar chart widget for data visualization
/// 
/// Usage:
/// ```dart
/// PlumerBarChart(
///   data: [
///     PlumerBarData(label: 'Jan', value: 100, color: Colors.blue),
///     PlumerBarData(label: 'Feb', value: 150, color: Colors.green),
///   ],
///   height: 200,
/// )
/// ```
class PlumerBarChart extends StatefulWidget {
  final List<PlumerBarData> data;
  final double height;
  final double barWidth;
  final double spacing;
  final Color? backgroundColor;
  final bool showLabels;
  final bool showValues;
  final bool animated;
  final Duration animationDuration;
  final EdgeInsetsGeometry? padding;

  const PlumerBarChart({
    super.key,
    required this.data,
    this.height = 200.0,
    this.barWidth = 32.0,
    this.spacing = 16.0,
    this.backgroundColor,
    this.showLabels = true,
    this.showValues = true,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 1200),
    this.padding,
  });

  @override
  State<PlumerBarChart> createState() => _PlumerBarChartState();
}

class _PlumerBarChartState extends State<PlumerBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    if (widget.animated) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxValue = widget.data.map((e) => e.value).reduce(math.max);
    
    return Container(
      padding: widget.padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: widget.height,
            child: AnimatedBuilder(
              animation: widget.animated ? _animation : const AlwaysStoppedAnimation(1.0),
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: widget.data.map((data) => _buildBar(theme, data, maxValue)).toList(),
                );
              },
            ),
          ),
          if (widget.showLabels) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.data.map((data) {
                return Text(
                  data.label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBar(ThemeData theme, PlumerBarData data, double maxValue) {
    final animationValue = widget.animated ? _animation.value : 1.0;
    final barHeight = (data.value / maxValue) * widget.height * animationValue;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (widget.showValues) ...[
          Text(
            data.value.toString(),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: data.color ?? theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Container(
          width: widget.barWidth,
          height: barHeight,
          decoration: BoxDecoration(
            color: data.color ?? theme.colorScheme.primary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            gradient: data.gradient,
          ),
        ),
      ],
    );
  }
}

/// Data model for bar chart
class PlumerBarData {
  final String label;
  final double value;
  final Color? color;
  final Gradient? gradient;

  const PlumerBarData({
    required this.label,
    required this.value,
    this.color,
    this.gradient,
  });
}

/// A donut chart widget for displaying data distribution
/// 
/// Usage:
/// ```dart
/// PlumerDonutChart(
///   data: [
///     PlumerDonutData(label: 'iOS', value: 40, color: Colors.blue),
///     PlumerDonutData(label: 'Android', value: 60, color: Colors.green),
///   ],
///   size: 200,
/// )
/// ```
class PlumerDonutChart extends StatefulWidget {
  final List<PlumerDonutData> data;
  final double size;
  final double strokeWidth;
  final bool showLabels;
  final bool showLegend;
  final Widget? centerWidget;
  final bool animated;
  final Duration animationDuration;

  const PlumerDonutChart({
    super.key,
    required this.data,
    this.size = 200.0,
    this.strokeWidth = 20.0,
    this.showLabels = false,
    this.showLegend = true,
    this.centerWidget,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<PlumerDonutChart> createState() => _PlumerDonutChartState();
}

class _PlumerDonutChartState extends State<PlumerDonutChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.animated) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.data.fold<double>(0, (sum, data) => sum + data.value);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: AnimatedBuilder(
            animation: widget.animated ? _animation : const AlwaysStoppedAnimation(1.0),
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _DonutChartPainter(
                      data: widget.data,
                      strokeWidth: widget.strokeWidth,
                      total: total,
                      animationValue: widget.animated ? _animation.value : 1.0,
                      showLabels: widget.showLabels,
                    ),
                  ),
                  if (widget.centerWidget != null) widget.centerWidget!,
                ],
              );
            },
          ),
        ),
        if (widget.showLegend) ...[
          const SizedBox(height: 16),
          _buildLegend(context, total),
        ],
      ],
    );
  }

  Widget _buildLegend(BuildContext context, double total) {
    final theme = Theme.of(context);
    
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: widget.data.map((data) {
        final percentage = (data.value / total * 100).round();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: data.color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${data.label} ($percentage%)',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

/// Custom painter for donut chart
class _DonutChartPainter extends CustomPainter {
  final List<PlumerDonutData> data;
  final double strokeWidth;
  final double total;
  final double animationValue;
  final bool showLabels;

  _DonutChartPainter({
    required this.data,
    required this.strokeWidth,
    required this.total,
    required this.animationValue,
    required this.showLabels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    double startAngle = -math.pi / 2;
    
    for (final segment in data) {
      final sweepAngle = (segment.value / total) * 2 * math.pi * animationValue;
      
      final paint = Paint()
        ..color = segment.color ?? Colors.grey
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      if (showLabels && animationValue > 0.8) {
        final labelAngle = startAngle + sweepAngle / 2;
        final labelRadius = radius + strokeWidth / 2 + 20;
        final labelPosition = Offset(
          center.dx + labelRadius * math.cos(labelAngle),
          center.dy + labelRadius * math.sin(labelAngle),
        );

        final textPainter = TextPainter(
          text: TextSpan(
            text: segment.label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          labelPosition - Offset(textPainter.width / 2, textPainter.height / 2),
        );
      }

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(_DonutChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Data model for donut chart
class PlumerDonutData {
  final String label;
  final double value;
  final Color? color;

  const PlumerDonutData({
    required this.label,
    required this.value,
    this.color,
  });
}

/// A sparkline chart for showing trends
/// 
/// Usage:
/// ```dart
/// PlumerSparkline(
///   data: [10, 30, 20, 40, 35, 55, 45],
///   lineColor: Colors.blue,
///   fillColor: Colors.blue.withOpacity(0.1),
/// )
/// ```
class PlumerSparkline extends StatefulWidget {
  final List<double> data;
  final double height;
  final Color? lineColor;
  final Color? fillColor;
  final double strokeWidth;
  final bool showDots;
  final bool filled;
  final bool animated;
  final Duration animationDuration;

  const PlumerSparkline({
    super.key,
    required this.data,
    this.height = 60.0,
    this.lineColor,
    this.fillColor,
    this.strokeWidth = 2.0,
    this.showDots = false,
    this.filled = false,
    this.animated = true,
    this.animationDuration = const Duration(milliseconds: 1000),
  });

  @override
  State<PlumerSparkline> createState() => _PlumerSparklineState();
}

class _PlumerSparklineState extends State<PlumerSparkline>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.animated) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: widget.animated ? _animation : const AlwaysStoppedAnimation(1.0),
        builder: (context, child) {
          return CustomPaint(
            painter: _SparklinePainter(
              data: widget.data,
              lineColor: widget.lineColor ?? theme.colorScheme.primary,
              fillColor: widget.fillColor,
              strokeWidth: widget.strokeWidth,
              showDots: widget.showDots,
              filled: widget.filled,
              animationValue: widget.animated ? _animation.value : 1.0,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

/// Custom painter for sparkline
class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final Color? fillColor;
  final double strokeWidth;
  final bool showDots;
  final bool filled;
  final double animationValue;

  _SparklinePainter({
    required this.data,
    required this.lineColor,
    this.fillColor,
    required this.strokeWidth,
    required this.showDots,
    required this.filled,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final minValue = data.reduce(math.min);
    final maxValue = data.reduce(math.max);
    final range = maxValue - minValue;
    
    if (range == 0) return;

    final stepWidth = size.width / (data.length - 1);
    final animatedLength = (data.length * animationValue).round();
    
    final path = Path();
    final points = <Offset>[];
    
    for (int i = 0; i < animatedLength; i++) {
      final x = i * stepWidth;
      final y = size.height - ((data[i] - minValue) / range) * size.height;
      final point = Offset(x, y);
      points.add(point);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Fill area under line
    if (filled && fillColor != null) {
      final fillPath = Path.from(path);
      if (points.isNotEmpty) {
        fillPath.lineTo(points.last.dx, size.height);
        fillPath.lineTo(points.first.dx, size.height);
        fillPath.close();
      }
      
      final fillPaint = Paint()
        ..color = fillColor!
        ..style = PaintingStyle.fill;
      
      canvas.drawPath(fillPath, fillPaint);
    }

    // Draw line
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);

    // Draw dots
    if (showDots) {
      final dotPaint = Paint()
        ..color = lineColor
        ..style = PaintingStyle.fill;

      for (final point in points) {
        canvas.drawCircle(point, strokeWidth * 1.5, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_SparklinePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}