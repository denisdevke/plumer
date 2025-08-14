import 'package:flutter/material.dart';

/// A modern avatar widget with status indicators and customizable styling
/// 
/// Usage:
/// ```dart
/// PlumerAvatar(
///   imageUrl: 'https://example.com/avatar.jpg',
///   size: PlumerAvatarSize.large,
///   status: PlumerAvatarStatus.online,
///   showBorder: true,
/// )
/// ```
class PlumerAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final PlumerAvatarSize size;
  final PlumerAvatarStatus? status;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool showBorder;
  final Color? borderColor;
  final double? borderWidth;
  final VoidCallback? onTap;
  final Widget? badge;
  final IconData? placeholderIcon;

  const PlumerAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = PlumerAvatarSize.medium,
    this.status,
    this.backgroundColor,
    this.foregroundColor,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth,
    this.onTap,
    this.badge,
    this.placeholderIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarSize = _getAvatarSize();
    final statusSize = _getStatusSize();
    
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: showBorder
                  ? Border.all(
                      color: borderColor ?? theme.colorScheme.outline,
                      width: borderWidth ?? 2.0,
                    )
                  : null,
            ),
            child: ClipOval(
              child: _buildAvatarContent(theme, avatarSize),
            ),
          ),
          // Status indicator
          if (status != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: statusSize,
                height: statusSize,
                decoration: BoxDecoration(
                  color: _getStatusColor(theme),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.scaffoldBackgroundColor,
                    width: 2,
                  ),
                ),
              ),
            ),
          // Badge
          if (badge != null)
            Positioned(
              right: -4,
              top: -4,
              child: badge!,
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarContent(ThemeData theme, double size) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallback(theme, size);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoading(theme, size);
        },
      );
    }
    
    return _buildFallback(theme, size);
  }

  Widget _buildFallback(ThemeData theme, double size) {
    final bgColor = backgroundColor ?? theme.colorScheme.primaryContainer;
    final fgColor = foregroundColor ?? theme.colorScheme.onPrimaryContainer;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: initials != null
            ? Text(
                initials!.toUpperCase(),
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.bold,
                  fontSize: size * 0.4,
                ),
              )
            : Icon(
                placeholderIcon ?? Icons.person,
                color: fgColor,
                size: size * 0.5,
              ),
      ),
    );
  }

  Widget _buildLoading(ThemeData theme, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.3,
          height: size * 0.3,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  double _getAvatarSize() {
    switch (size) {
      case PlumerAvatarSize.small:
        return 32.0;
      case PlumerAvatarSize.medium:
        return 48.0;
      case PlumerAvatarSize.large:
        return 64.0;
      case PlumerAvatarSize.extraLarge:
        return 88.0;
    }
  }

  double _getStatusSize() {
    switch (size) {
      case PlumerAvatarSize.small:
        return 10.0;
      case PlumerAvatarSize.medium:
        return 12.0;
      case PlumerAvatarSize.large:
        return 16.0;
      case PlumerAvatarSize.extraLarge:
        return 20.0;
    }
  }

  Color _getStatusColor(ThemeData theme) {
    switch (status!) {
      case PlumerAvatarStatus.online:
        return Colors.green;
      case PlumerAvatarStatus.away:
        return Colors.orange;
      case PlumerAvatarStatus.busy:
        return Colors.red;
      case PlumerAvatarStatus.offline:
        return theme.colorScheme.outline;
    }
  }
}

/// Avatar sizes
enum PlumerAvatarSize {
  small,
  medium,
  large,
  extraLarge,
}

/// Avatar status indicators
enum PlumerAvatarStatus {
  online,
  away,
  busy,
  offline,
}

/// A group of stacked avatars showing multiple users
/// 
/// Usage:
/// ```dart
/// PlumerAvatarGroup(
///   avatars: [
///     PlumerAvatar(imageUrl: 'url1', size: PlumerAvatarSize.small),
///     PlumerAvatar(imageUrl: 'url2', size: PlumerAvatarSize.small),
///   ],
///   maxVisible: 3,
///   spacing: -8,
/// )
/// ```
class PlumerAvatarGroup extends StatelessWidget {
  final List<PlumerAvatar> avatars;
  final int maxVisible;
  final double spacing;
  final VoidCallback? onTap;
  final TextStyle? overflowTextStyle;

  const PlumerAvatarGroup({
    super.key,
    required this.avatars,
    this.maxVisible = 4,
    this.spacing = -8.0,
    this.onTap,
    this.overflowTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visibleAvatars = avatars.take(maxVisible - 1).toList();
    final overflowCount = avatars.length - visibleAvatars.length;
    
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...visibleAvatars.asMap().entries.map((entry) {
            final index = entry.key;
            final avatar = entry.value;
            
            return Container(
              margin: EdgeInsets.only(left: index > 0 ? spacing : 0),
              child: avatar,
            );
          }),
          if (overflowCount > 0)
            Container(
              margin: EdgeInsets.only(left: spacing),
              child: _buildOverflowAvatar(theme, overflowCount),
            ),
        ],
      ),
    );
  }

  Widget _buildOverflowAvatar(ThemeData theme, int count) {
    final size = avatars.isNotEmpty ? avatars.first._getAvatarSize() : 48.0;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.scaffoldBackgroundColor,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '+$count',
          style: overflowTextStyle ?? theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// A profile card widget with avatar and user information
/// 
/// Usage:
/// ```dart
/// PlumerProfileCard(
///   avatar: PlumerAvatar(imageUrl: 'url', size: PlumerAvatarSize.large),
///   name: 'John Doe',
///   subtitle: 'Software Developer',
///   description: 'Building amazing apps',
///   actions: [
///     IconButton(onPressed: () {}, icon: Icon(Icons.message)),
///   ],
/// )
/// ```
class PlumerProfileCard extends StatelessWidget {
  final PlumerAvatar avatar;
  final String name;
  final String? subtitle;
  final String? description;
  final List<Widget>? actions;
  final List<PlumerProfileStat>? stats;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const PlumerProfileCard({
    super.key,
    required this.avatar,
    required this.name,
    this.subtitle,
    this.description,
    this.actions,
    this.stats,
    this.onTap,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      color: backgroundColor ?? theme.cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              avatar,
              const SizedBox(height: 16),
              Text(
                name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (description != null) ...[
                const SizedBox(height: 8),
                Text(
                  description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (stats != null && stats!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: stats!.map((stat) => _buildStat(theme, stat)).toList(),
                ),
              ],
              if (actions != null && actions!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: actions!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(ThemeData theme, PlumerProfileStat stat) {
    return Column(
      children: [
        Text(
          stat.value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          stat.label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

/// Profile statistics data model
class PlumerProfileStat {
  final String label;
  final String value;

  const PlumerProfileStat({
    required this.label,
    required this.value,
  });
}

/// A compact user tile for lists
/// 
/// Usage:
/// ```dart
/// PlumerUserTile(
///   avatar: PlumerAvatar(imageUrl: 'url'),
///   name: 'John Doe',
///   subtitle: 'Online',
///   trailing: Icon(Icons.chevron_right),
///   onTap: () {},
/// )
/// ```
class PlumerUserTile extends StatelessWidget {
  final PlumerAvatar avatar;
  final String name;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final bool selected;

  const PlumerUserTile({
    super.key,
    required this.avatar,
    required this.name,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.contentPadding,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return ListTile(
      contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: avatar,
      title: Text(
        name,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: selected ? theme.colorScheme.primary : null,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            )
          : null,
      trailing: trailing,
      selected: selected,
      selectedTileColor: theme.colorScheme.primaryContainer.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: onTap,
    );
  }
}

/// A skeleton loader for avatars
/// 
/// Usage:
/// ```dart
/// PlumerAvatarSkeleton(
///   size: PlumerAvatarSize.large,
///   showStatus: true,
/// )
/// ```
class PlumerAvatarSkeleton extends StatefulWidget {
  final PlumerAvatarSize size;
  final bool showStatus;
  final Color? baseColor;
  final Color? highlightColor;

  const PlumerAvatarSkeleton({
    super.key,
    this.size = PlumerAvatarSize.medium,
    this.showStatus = false,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<PlumerAvatarSkeleton> createState() => _PlumerAvatarSkeletonState();
}

class _PlumerAvatarSkeletonState extends State<PlumerAvatarSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avatarSize = _getAvatarSize();
    final statusSize = _getStatusSize();
    final isDark = theme.brightness == Brightness.dark;
    
    final baseColor = widget.baseColor ??
        (isDark ? Colors.grey[800]! : Colors.grey[300]!);
    final highlightColor = widget.highlightColor ??
        (isDark ? Colors.grey[700]! : Colors.grey[100]!);

    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [
                    (_animation.value - 0.3).clamp(0.0, 1.0),
                    _animation.value.clamp(0.0, 1.0),
                    (_animation.value + 0.3).clamp(0.0, 1.0),
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
        ),
        if (widget.showStatus)
          Positioned(
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: statusSize,
                  height: statusSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [baseColor, highlightColor, baseColor],
                    ),
                    border: Border.all(
                      color: theme.scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  double _getAvatarSize() {
    switch (widget.size) {
      case PlumerAvatarSize.small:
        return 32.0;
      case PlumerAvatarSize.medium:
        return 48.0;
      case PlumerAvatarSize.large:
        return 64.0;
      case PlumerAvatarSize.extraLarge:
        return 88.0;
    }
  }

  double _getStatusSize() {
    switch (widget.size) {
      case PlumerAvatarSize.small:
        return 10.0;
      case PlumerAvatarSize.medium:
        return 12.0;
      case PlumerAvatarSize.large:
        return 16.0;
      case PlumerAvatarSize.extraLarge:
        return 20.0;
    }
  }
}