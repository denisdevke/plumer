import 'package:flutter/material.dart';

/// A modern, customizable card widget with various layouts and animations
/// 
/// Usage:
/// ```dart
/// PlumerCard(
///   child: Text('Card content'),
///   variant: PlumerCardVariant.elevated,
///   onTap: () => print('Card tapped'),
/// )
/// ```
class PlumerCard extends StatefulWidget {
  final Widget child;
  final PlumerCardVariant variant;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? elevation;
  final bool isSelected;
  final Widget? header;
  final Widget? footer;

  const PlumerCard({
    super.key,
    required this.child,
    this.variant = PlumerCardVariant.elevated,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.elevation,
    this.isSelected = false,
    this.header,
    this.footer,
  });

  @override
  State<PlumerCard> createState() => _PlumerCardState();
}

class _PlumerCardState extends State<PlumerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
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
    final config = _getCardConfig(theme);
    
    return Container(
      margin: widget.margin,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? config.backgroundColor,
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? config.borderRadius,
                ),
                border: widget.isSelected
                    ? Border.all(
                        color: theme.colorScheme.primary,
                        width: 2.0,
                      )
                    : config.borderColor != null
                        ? Border.all(
                            color: widget.borderColor ?? config.borderColor!,
                            width: 1.0,
                          )
                        : null,
                boxShadow: widget.elevation != null || config.elevation > 0
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: widget.elevation ?? config.elevation,
                          offset: Offset(
                            0,
                            (widget.elevation ?? config.elevation) / 2,
                          ),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? config.borderRadius,
                ),
                child: InkWell(
                  onTap: widget.onTap,
                  onTapDown: widget.onTap != null ? (_) => _onTapDown() : null,
                  onTapUp: widget.onTap != null ? (_) => _onTapUp() : null,
                  onTapCancel: widget.onTap != null ? _onTapCancel : null,
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? config.borderRadius,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.header != null) ...[
                        widget.header!,
                        if (widget.padding != null || config.padding != null)
                          const Divider(height: 1),
                      ],
                      Padding(
                        padding: widget.padding ?? config.padding,
                        child: widget.child,
                      ),
                      if (widget.footer != null) ...[
                        if (widget.padding != null || config.padding != null)
                          const Divider(height: 1),
                        widget.footer!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onTapDown() {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  _CardConfig _getCardConfig(ThemeData theme) {
    switch (widget.variant) {
      case PlumerCardVariant.elevated:
        return _CardConfig(
          backgroundColor: theme.cardColor,
          elevation: 4.0,
          borderRadius: 12.0,
          padding: const EdgeInsets.all(16.0),
        );
      
      case PlumerCardVariant.outlined:
        return _CardConfig(
          backgroundColor: theme.cardColor,
          borderColor: theme.colorScheme.outline,
          elevation: 0.0,
          borderRadius: 12.0,
          padding: const EdgeInsets.all(16.0),
        );
      
      case PlumerCardVariant.filled:
        return _CardConfig(
          backgroundColor: theme.colorScheme.surfaceVariant,
          elevation: 0.0,
          borderRadius: 12.0,
          padding: const EdgeInsets.all(16.0),
        );
    }
  }
}

/// Card variant enum defining different visual styles
enum PlumerCardVariant {
  elevated,
  outlined,
  filled,
}

/// Internal configuration class for card styling
class _CardConfig {
  final Color backgroundColor;
  final Color? borderColor;
  final double elevation;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  _CardConfig({
    required this.backgroundColor,
    this.borderColor,
    required this.elevation,
    required this.borderRadius,
    required this.padding,
  });
}

/// A feature card with icon, title, and description
/// 
/// Usage:
/// ```dart
/// PlumerFeatureCard(
///   icon: Icons.star,
///   title: 'Premium Feature',
///   description: 'This is a premium feature description',
///   onTap: () => print('Feature tapped'),
/// )
/// ```
class PlumerFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool isCompact;

  const PlumerFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return PlumerCard(
      onTap: onTap,
      backgroundColor: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isCompact ? 40 : 48,
            height: isCompact ? 40 : 48,
            decoration: BoxDecoration(
              color: (iconColor ?? theme.colorScheme.primary).withOpacity(0.1),
              borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
            ),
            child: Icon(
              icon,
              color: iconColor ?? theme.colorScheme.primary,
              size: isCompact ? 20 : 24,
            ),
          ),
          SizedBox(height: isCompact ? 12 : 16),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// A profile card with avatar, name, and details
/// 
/// Usage:
/// ```dart
/// PlumerProfileCard(
///   imageUrl: 'https://example.com/avatar.jpg',
///   name: 'John Doe',
///   subtitle: 'Software Developer',
///   onTap: () => print('Profile tapped'),
/// )
/// ```
class PlumerProfileCard extends StatelessWidget {
  final String? imageUrl;
  final IconData? placeholderIcon;
  final String name;
  final String? subtitle;
  final String? description;
  final VoidCallback? onTap;
  final List<Widget>? actions;
  final bool isHorizontal;

  const PlumerProfileCard({
    super.key,
    this.imageUrl,
    this.placeholderIcon,
    required this.name,
    this.subtitle,
    this.description,
    this.onTap,
    this.actions,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return PlumerCard(
      onTap: onTap,
      child: isHorizontal ? _buildHorizontalLayout(theme) : _buildVerticalLayout(theme),
    );
  }

  Widget _buildHorizontalLayout(ThemeData theme) {
    return Row(
      children: [
        _buildAvatar(theme),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
              if (description != null) ...[
                const SizedBox(height: 8),
                Text(
                  description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        if (actions != null) ...[
          const SizedBox(width: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: actions!,
          ),
        ],
      ],
    );
  }

  Widget _buildVerticalLayout(ThemeData theme) {
    return Column(
      children: [
        _buildAvatar(theme, size: 80),
        const SizedBox(height: 16),
        Text(
          name,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (description != null) ...[
          const SizedBox(height: 12),
          Text(
            description!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (actions != null) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: actions!,
          ),
        ],
      ],
    );
  }

  Widget _buildAvatar(ThemeData theme, {double size = 48}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        color: theme.colorScheme.primaryContainer,
      ),
      child: imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(size / 2),
              child: Image.network(
                imageUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder(theme, size);
                },
              ),
            )
          : _buildPlaceholder(theme, size),
    );
  }

  Widget _buildPlaceholder(ThemeData theme, double size) {
    return Icon(
      placeholderIcon ?? Icons.person,
      color: theme.colorScheme.onPrimaryContainer,
      size: size * 0.5,
    );
  }
}

/// A stats card displaying a metric with optional trend
/// 
/// Usage:
/// ```dart
/// PlumerStatsCard(
///   title: 'Total Users',
///   value: '1,234',
///   trend: '+12%',
///   trendDirection: PlumerTrendDirection.up,
///   icon: Icons.people,
/// )
/// ```
class PlumerStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? trend;
  final PlumerTrendDirection? trendDirection;
  final IconData? icon;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const PlumerStatsCard({
    super.key,
    required this.title,
    required this.value,
    this.trend,
    this.trendDirection,
    this.icon,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return PlumerCard(
      onTap: onTap,
      backgroundColor: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (trend != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _getTrendIcon(),
                  color: _getTrendColor(theme),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  trend!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: _getTrendColor(theme),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  IconData _getTrendIcon() {
    switch (trendDirection) {
      case PlumerTrendDirection.up:
        return Icons.trending_up;
      case PlumerTrendDirection.down:
        return Icons.trending_down;
      case PlumerTrendDirection.neutral:
        return Icons.trending_flat;
      case null:
        return Icons.trending_flat;
    }
  }

  Color _getTrendColor(ThemeData theme) {
    switch (trendDirection) {
      case PlumerTrendDirection.up:
        return Colors.green;
      case PlumerTrendDirection.down:
        return Colors.red;
      case PlumerTrendDirection.neutral:
        return theme.colorScheme.onSurface.withOpacity(0.6);
      case null:
        return theme.colorScheme.onSurface.withOpacity(0.6);
    }
  }
}

enum PlumerTrendDirection {
  up,
  down,
  neutral,
}

/// A media card with image, title, and description
/// 
/// Usage:
/// ```dart
/// PlumerMediaCard(
///   imageUrl: 'https://example.com/image.jpg',
///   title: 'Card Title',
///   description: 'Card description text',
///   onTap: () => print('Media card tapped'),
/// )
/// ```
class PlumerMediaCard extends StatelessWidget {
  final String? imageUrl;
  final Widget? image;
  final String title;
  final String? description;
  final VoidCallback? onTap;
  final List<Widget>? actions;
  final double? imageHeight;
  final BoxFit imageFit;

  const PlumerMediaCard({
    super.key,
    this.imageUrl,
    this.image,
    required this.title,
    this.description,
    this.onTap,
    this.actions,
    this.imageHeight,
    this.imageFit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return PlumerCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null || image != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: imageHeight ?? 200,
                width: double.infinity,
                child: image ??
                    Image.network(
                      imageUrl!,
                      fit: imageFit,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.colorScheme.surfaceVariant,
                          child: Icon(
                            Icons.image,
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 48,
                          ),
                        );
                      },
                    ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
                if (actions != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: actions!,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}