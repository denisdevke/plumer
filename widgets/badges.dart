import 'package:flutter/material.dart';

/// A modern badge widget for notifications and status indicators
/// 
/// Usage:
/// ```dart
/// PlumerBadge(
///   count: 5,
///   child: Icon(Icons.notifications),
/// )
/// ```
class PlumerBadge extends StatelessWidget {
  final Widget child;
  final int? count;
  final String? text;
  final PlumerBadgeStyle style;
  final Color? backgroundColor;
  final Color? textColor;
  final double? size;
  final bool showZero;
  final VoidCallback? onTap;
  final Offset offset;

  const PlumerBadge({
    super.key,
    required this.child,
    this.count,
    this.text,
    this.style = PlumerBadgeStyle.count,
    this.backgroundColor,
    this.textColor,
    this.size,
    this.showZero = false,
    this.onTap,
    this.offset = const Offset(8, -8),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shouldShow = _shouldShowBadge();
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (shouldShow)
          Positioned(
            top: offset.dy,
            right: offset.dx,
            child: GestureDetector(
              onTap: onTap,
              child: _buildBadge(theme),
            ),
          ),
      ],
    );
  }

  bool _shouldShowBadge() {
    if (text != null && text!.isNotEmpty) return true;
    if (count != null) {
      return showZero || count! > 0;
    }
    return false;
  }

  Widget _buildBadge(ThemeData theme) {
    final bgColor = backgroundColor ?? theme.colorScheme.error;
    final fgColor = textColor ?? theme.colorScheme.onError;
    final badgeSize = size ?? 20.0;
    
    switch (style) {
      case PlumerBadgeStyle.count:
        return _buildCountBadge(theme, bgColor, fgColor, badgeSize);
      case PlumerBadgeStyle.dot:
        return _buildDotBadge(theme, bgColor, badgeSize);
      case PlumerBadgeStyle.icon:
        return _buildIconBadge(theme, bgColor, fgColor, badgeSize);
    }
  }

  Widget _buildCountBadge(ThemeData theme, Color bgColor, Color fgColor, double badgeSize) {
    final displayText = text ?? (count != null ? count.toString() : '');
    final isLarge = displayText.length > 2;
    
    return Container(
      constraints: BoxConstraints(
        minWidth: badgeSize,
        minHeight: badgeSize,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 6 : 0,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(badgeSize / 2),
        border: Border.all(
          color: theme.scaffoldBackgroundColor,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          displayText,
          style: theme.textTheme.labelSmall?.copyWith(
            color: fgColor,
            fontWeight: FontWeight.bold,
            fontSize: badgeSize * 0.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDotBadge(ThemeData theme, Color bgColor, double badgeSize) {
    return Container(
      width: badgeSize * 0.6,
      height: badgeSize * 0.6,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.scaffoldBackgroundColor,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildIconBadge(ThemeData theme, Color bgColor, Color fgColor, double badgeSize) {
    return Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.scaffoldBackgroundColor,
          width: 2,
        ),
      ),
      child: Icon(
        Icons.priority_high,
        color: fgColor,
        size: badgeSize * 0.6,
      ),
    );
  }
}

/// Badge display styles
enum PlumerBadgeStyle {
  count,
  dot,
  icon,
}

/// A modern chip widget for tags, filters, and selections
/// 
/// Usage:
/// ```dart
/// PlumerChip(
///   label: 'Flutter',
///   selected: true,
///   onTap: () {},
///   avatar: Icon(Icons.code),
/// )
/// ```
class PlumerChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final Widget? avatar;
  final IconData? deleteIcon;
  final PlumerChipStyle style;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? textColor;
  final Color? selectedTextColor;
  final EdgeInsetsGeometry? padding;
  final double? height;

  const PlumerChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.onDeleted,
    this.avatar,
    this.deleteIcon,
    this.style = PlumerChipStyle.filled,
    this.backgroundColor,
    this.selectedColor,
    this.textColor,
    this.selectedTextColor,
    this.padding,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height ?? 32.0,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: _getDecoration(theme),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (avatar != null) ...[
              SizedBox(
                width: 20,
                height: 20,
                child: avatar,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: _getTextColor(theme),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (onDeleted != null) ...[
              const SizedBox(width: 6),
              GestureDetector(
                onTap: onDeleted,
                child: Icon(
                  deleteIcon ?? Icons.close,
                  size: 16,
                  color: _getTextColor(theme).withOpacity(0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  BoxDecoration _getDecoration(ThemeData theme) {
    final bgColor = _getBackgroundColor(theme);
    
    switch (style) {
      case PlumerChipStyle.filled:
        return BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        );
      case PlumerChipStyle.outlined:
        return BoxDecoration(
          color: selected ? bgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected 
                ? (selectedColor ?? theme.colorScheme.primary)
                : theme.colorScheme.outline,
            width: 1.5,
          ),
        );
      case PlumerChipStyle.elevated:
        return BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: (selectedColor ?? theme.colorScheme.primary).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        );
    }
  }

  Color _getBackgroundColor(ThemeData theme) {
    if (selected) {
      return selectedColor ?? theme.colorScheme.primaryContainer;
    }
    return backgroundColor ?? theme.colorScheme.surfaceVariant;
  }

  Color _getTextColor(ThemeData theme) {
    if (selected) {
      return selectedTextColor ?? theme.colorScheme.onPrimaryContainer;
    }
    return textColor ?? theme.colorScheme.onSurfaceVariant;
  }
}

/// Chip display styles
enum PlumerChipStyle {
  filled,
  outlined,
  elevated,
}

/// A group of chips with selection management
/// 
/// Usage:
/// ```dart
/// PlumerChipGroup(
///   chips: ['All', 'Work', 'Personal', 'Important'],
///   selectedIndex: 0,
///   onSelectionChanged: (index) {},
/// )
/// ```
class PlumerChipGroup extends StatelessWidget {
  final List<String> chips;
  final int? selectedIndex;
  final List<int>? selectedIndices; // For multi-select
  final ValueChanged<int>? onSelectionChanged;
  final ValueChanged<List<int>>? onMultiSelectionChanged;
  final bool multiSelect;
  final PlumerChipStyle style;
  final Color? backgroundColor;
  final Color? selectedColor;
  final EdgeInsetsGeometry? padding;
  final double spacing;
  final double runSpacing;
  final WrapAlignment alignment;

  const PlumerChipGroup({
    super.key,
    required this.chips,
    this.selectedIndex,
    this.selectedIndices,
    this.onSelectionChanged,
    this.onMultiSelectionChanged,
    this.multiSelect = false,
    this.style = PlumerChipStyle.filled,
    this.backgroundColor,
    this.selectedColor,
    this.padding,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    this.alignment = WrapAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        alignment: alignment,
        children: chips.asMap().entries.map((entry) {
          final index = entry.key;
          final chip = entry.value;
          final isSelected = _isSelected(index);

          return PlumerChip(
            label: chip,
            selected: isSelected,
            style: style,
            backgroundColor: backgroundColor,
            selectedColor: selectedColor,
            onTap: () => _handleTap(index),
          );
        }).toList(),
      ),
    );
  }

  bool _isSelected(int index) {
    if (multiSelect) {
      return selectedIndices?.contains(index) ?? false;
    }
    return selectedIndex == index;
  }

  void _handleTap(int index) {
    if (multiSelect) {
      final currentSelection = List<int>.from(selectedIndices ?? []);
      if (currentSelection.contains(index)) {
        currentSelection.remove(index);
      } else {
        currentSelection.add(index);
      }
      onMultiSelectionChanged?.call(currentSelection);
    } else {
      onSelectionChanged?.call(index);
    }
  }
}

/// A notification badge with modern styling and animations
/// 
/// Usage:
/// ```dart
/// PlumerNotificationBadge(
///   type: PlumerNotificationType.success,
///   title: 'Success',
///   message: 'Your action completed successfully',
///   showCloseButton: true,
/// )
/// ```
class PlumerNotificationBadge extends StatefulWidget {
  final PlumerNotificationType type;
  final String title;
  final String? message;
  final IconData? icon;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final VoidCallback? onTap;
  final Duration? autoCloseDuration;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const PlumerNotificationBadge({
    super.key,
    required this.type,
    required this.title,
    this.message,
    this.icon,
    this.showCloseButton = true,
    this.onClose,
    this.onTap,
    this.autoCloseDuration,
    this.margin,
    this.padding,
  });

  @override
  State<PlumerNotificationBadge> createState() => _PlumerNotificationBadgeState();
}

class _PlumerNotificationBadgeState extends State<PlumerNotificationBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _controller.forward();

    if (widget.autoCloseDuration != null) {
      Future.delayed(widget.autoCloseDuration!, () {
        if (mounted) {
          _close();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() {
    _controller.reverse().then((_) {
      widget.onClose?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _getTypeColors(theme);
    
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 100),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: widget.margin ?? const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colors.primary.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: widget.padding ?? const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            widget.icon ?? _getDefaultIcon(),
                            color: colors.onPrimary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.title,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colors.primary,
                                ),
                              ),
                              if (widget.message != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  widget.message!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (widget.showCloseButton) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: _close,
                            icon: Icon(
                              Icons.close,
                              size: 18,
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _NotificationColors _getTypeColors(ThemeData theme) {
    switch (widget.type) {
      case PlumerNotificationType.success:
        return _NotificationColors(
          primary: Colors.green,
          background: Colors.green.withOpacity(0.1),
          onPrimary: Colors.white,
        );
      case PlumerNotificationType.error:
        return _NotificationColors(
          primary: Colors.red,
          background: Colors.red.withOpacity(0.1),
          onPrimary: Colors.white,
        );
      case PlumerNotificationType.warning:
        return _NotificationColors(
          primary: Colors.orange,
          background: Colors.orange.withOpacity(0.1),
          onPrimary: Colors.white,
        );
      case PlumerNotificationType.info:
        return _NotificationColors(
          primary: Colors.blue,
          background: Colors.blue.withOpacity(0.1),
          onPrimary: Colors.white,
        );
    }
  }

  IconData _getDefaultIcon() {
    switch (widget.type) {
      case PlumerNotificationType.success:
        return Icons.check_circle;
      case PlumerNotificationType.error:
        return Icons.error;
      case PlumerNotificationType.warning:
        return Icons.warning;
      case PlumerNotificationType.info:
        return Icons.info;
    }
  }
}

/// Notification types
enum PlumerNotificationType {
  success,
  error,
  warning,
  info,
}

/// Helper class for notification colors
class _NotificationColors {
  final Color primary;
  final Color background;
  final Color onPrimary;

  _NotificationColors({
    required this.primary,
    required this.background,
    required this.onPrimary,
  });
}

/// A status indicator chip
/// 
/// Usage:
/// ```dart
/// PlumerStatusChip(
///   status: PlumerStatus.active,
///   label: 'Active',
/// )
/// ```
class PlumerStatusChip extends StatelessWidget {
  final PlumerStatus status;
  final String? label;
  final double size;
  final bool showLabel;

  const PlumerStatusChip({
    super.key,
    required this.status,
    this.label,
    this.size = 8.0,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor();
    final statusLabel = label ?? _getStatusLabel();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
        if (showLabel && statusLabel.isNotEmpty) ...[
          const SizedBox(width: 6),
          Text(
            statusLabel,
            style: theme.textTheme.labelSmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case PlumerStatus.active:
        return Colors.green;
      case PlumerStatus.inactive:
        return Colors.grey;
      case PlumerStatus.pending:
        return Colors.orange;
      case PlumerStatus.error:
        return Colors.red;
      case PlumerStatus.success:
        return Colors.green;
      case PlumerStatus.warning:
        return Colors.orange;
    }
  }

  String _getStatusLabel() {
    switch (status) {
      case PlumerStatus.active:
        return 'Active';
      case PlumerStatus.inactive:
        return 'Inactive';
      case PlumerStatus.pending:
        return 'Pending';
      case PlumerStatus.error:
        return 'Error';
      case PlumerStatus.success:
        return 'Success';
      case PlumerStatus.warning:
        return 'Warning';
    }
  }
}

/// Status types
enum PlumerStatus {
  active,
  inactive,
  pending,
  error,
  success,
  warning,
}