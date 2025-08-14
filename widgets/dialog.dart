import 'package:flutter/material.dart';

/// A modern dialog widget with customizable styling
/// 
/// Usage:
/// ```dart
/// PlumerDialog.show(
///   context: context,
///   title: 'Confirm Action',
///   content: 'Are you sure you want to delete this item?',
///   primaryAction: PlumerDialogAction(
///     text: 'Delete',
///     onPressed: () => Navigator.of(context).pop(true),
///     isDestructive: true,
///   ),
///   secondaryAction: PlumerDialogAction(
///     text: 'Cancel',
///     onPressed: () => Navigator.of(context).pop(false),
///   ),
/// );
/// ```
class PlumerDialog extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final String? content;
  final Widget? contentWidget;
  final PlumerDialogAction? primaryAction;
  final PlumerDialogAction? secondaryAction;
  final List<PlumerDialogAction>? actions;
  final IconData? icon;
  final Color? iconColor;
  final double? width;
  final EdgeInsetsGeometry? contentPadding;
  final bool barrierDismissible;

  const PlumerDialog({
    super.key,
    this.title,
    this.titleWidget,
    this.content,
    this.contentWidget,
    this.primaryAction,
    this.secondaryAction,
    this.actions,
    this.icon,
    this.iconColor,
    this.width,
    this.contentPadding,
    this.barrierDismissible = true,
  });

  /// Show a dialog with the given configuration
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    Widget? titleWidget,
    String? content,
    Widget? contentWidget,
    PlumerDialogAction? primaryAction,
    PlumerDialogAction? secondaryAction,
    List<PlumerDialogAction>? actions,
    IconData? icon,
    Color? iconColor,
    double? width,
    EdgeInsetsGeometry? contentPadding,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => PlumerDialog(
        title: title,
        titleWidget: titleWidget,
        content: content,
        contentWidget: contentWidget,
        primaryAction: primaryAction,
        secondaryAction: secondaryAction,
        actions: actions,
        icon: icon,
        iconColor: iconColor,
        width: width,
        contentPadding: contentPadding,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: width ?? 320,
        constraints: const BoxConstraints(
          maxHeight: 400,
          maxWidth: 400,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            if (icon != null || title != null || titleWidget != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    if (icon != null) ...[
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: (iconColor ?? theme.colorScheme.primary)
                              .withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: iconColor ?? theme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (titleWidget != null)
                      titleWidget!
                    else if (title != null)
                      Text(
                        title!,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              ),
            
            // Content
            if (content != null || contentWidget != null)
              Flexible(
                child: Padding(
                  padding: contentPadding ??
                      EdgeInsets.fromLTRB(
                        24,
                        icon != null || title != null || titleWidget != null ? 0 : 24,
                        24,
                        24,
                      ),
                  child: contentWidget ??
                      Text(
                        content ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                ),
              ),
            
            // Actions
            if (_hasActions())
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: _buildActions(theme),
              ),
          ],
        ),
      ),
    );
  }

  bool _hasActions() {
    return primaryAction != null || 
           secondaryAction != null || 
           (actions != null && actions!.isNotEmpty);
  }

  Widget _buildActions(ThemeData theme) {
    final allActions = actions ?? 
        [
          if (secondaryAction != null) secondaryAction!,
          if (primaryAction != null) primaryAction!,
        ];

    if (allActions.length <= 2) {
      return Row(
        children: [
          if (allActions.length == 2) ...[
            Expanded(
              child: _buildActionButton(allActions[0], theme, isSecondary: true),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(allActions[1], theme),
            ),
          ] else ...[
            Expanded(
              child: _buildActionButton(allActions[0], theme),
            ),
          ],
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: allActions.map((action) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _buildActionButton(action, theme),
          );
        }).toList(),
      );
    }
  }

  Widget _buildActionButton(PlumerDialogAction action, ThemeData theme, {bool isSecondary = false}) {
    return ElevatedButton(
      onPressed: action.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: action.isDestructive
            ? theme.colorScheme.error
            : isSecondary
                ? theme.colorScheme.surfaceVariant
                : theme.colorScheme.primary,
        foregroundColor: action.isDestructive
            ? theme.colorScheme.onError
            : isSecondary
                ? theme.colorScheme.onSurfaceVariant
                : theme.colorScheme.onPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        action.text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Action configuration for dialog buttons
class PlumerDialogAction {
  final String text;
  final VoidCallback? onPressed;
  final bool isDestructive;

  const PlumerDialogAction({
    required this.text,
    this.onPressed,
    this.isDestructive = false,
  });
}

/// A modern bottom sheet widget
/// 
/// Usage:
/// ```dart
/// PlumerBottomSheet.show(
///   context: context,
///   title: 'Select Option',
///   child: Column(
///     children: [
///       ListTile(
///         leading: Icon(Icons.photo),
///         title: Text('Photo'),
///         onTap: () => Navigator.of(context).pop('photo'),
///       ),
///     ],
///   ),
/// );
/// ```
class PlumerBottomSheet extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget child;
  final bool isDismissible;
  final bool enableDrag;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const PlumerBottomSheet({
    super.key,
    this.title,
    this.titleWidget,
    required this.child,
    this.isDismissible = true,
    this.enableDrag = true,
    this.height,
    this.padding,
  });

  /// Show a bottom sheet with the given configuration
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    Widget? titleWidget,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
    EdgeInsetsGeometry? padding,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => PlumerBottomSheet(
        title: title,
        titleWidget: titleWidget,
        height: height,
        padding: padding,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    
    return Container(
      height: height,
      constraints: BoxConstraints(
        maxHeight: mediaQuery.size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          if (enableDrag) ...[
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
          ],
          
          // Header
          if (title != null || titleWidget != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                children: [
                  Expanded(
                    child: titleWidget ??
                        Text(
                          title ?? '',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  ),
                  if (isDismissible)
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      iconSize: 20,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          ],
          
          // Content
          Flexible(
            child: Padding(
              padding: padding ?? const EdgeInsets.all(24),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// A modern alert dialog with predefined configurations
class PlumerAlert {
  /// Show a success alert dialog
  static Future<void> success({
    required BuildContext context,
    String? title,
    String? message,
    String? buttonText,
  }) {
    return PlumerDialog.show(
      context: context,
      title: title ?? 'Success',
      content: message ?? 'Operation completed successfully.',
      icon: Icons.check_circle,
      iconColor: Colors.green,
      primaryAction: PlumerDialogAction(
        text: buttonText ?? 'OK',
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// Show an error alert dialog
  static Future<void> error({
    required BuildContext context,
    String? title,
    String? message,
    String? buttonText,
  }) {
    return PlumerDialog.show(
      context: context,
      title: title ?? 'Error',
      content: message ?? 'An error occurred. Please try again.',
      icon: Icons.error,
      iconColor: Colors.red,
      primaryAction: PlumerDialogAction(
        text: buttonText ?? 'OK',
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// Show a warning alert dialog
  static Future<void> warning({
    required BuildContext context,
    String? title,
    String? message,
    String? buttonText,
  }) {
    return PlumerDialog.show(
      context: context,
      title: title ?? 'Warning',
      content: message ?? 'Please review your action.',
      icon: Icons.warning,
      iconColor: Colors.orange,
      primaryAction: PlumerDialogAction(
        text: buttonText ?? 'OK',
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  /// Show a confirmation dialog
  static Future<bool> confirm({
    required BuildContext context,
    String? title,
    String? message,
    String? confirmText,
    String? cancelText,
    bool isDestructive = false,
  }) async {
    final result = await PlumerDialog.show<bool>(
      context: context,
      title: title ?? 'Confirm',
      content: message ?? 'Are you sure you want to proceed?',
      icon: isDestructive ? Icons.warning : Icons.help_outline,
      iconColor: isDestructive ? Colors.red : null,
      primaryAction: PlumerDialogAction(
        text: confirmText ?? (isDestructive ? 'Delete' : 'Confirm'),
        isDestructive: isDestructive,
        onPressed: () => Navigator.of(context).pop(true),
      ),
      secondaryAction: PlumerDialogAction(
        text: cancelText ?? 'Cancel',
        onPressed: () => Navigator.of(context).pop(false),
      ),
    );
    
    return result ?? false;
  }
}

/// A modern snackbar widget with customizable styling
class PlumerSnackbar {
  /// Show a success snackbar
  static void success({
    required BuildContext context,
    required String message,
    Duration? duration,
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) {
    _show(
      context: context,
      message: message,
      icon: Icons.check_circle,
      backgroundColor: Colors.green,
      duration: duration,
      onActionPressed: onActionPressed,
      actionLabel: actionLabel,
    );
  }

  /// Show an error snackbar
  static void error({
    required BuildContext context,
    required String message,
    Duration? duration,
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) {
    _show(
      context: context,
      message: message,
      icon: Icons.error,
      backgroundColor: Colors.red,
      duration: duration,
      onActionPressed: onActionPressed,
      actionLabel: actionLabel,
    );
  }

  /// Show an info snackbar
  static void info({
    required BuildContext context,
    required String message,
    Duration? duration,
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) {
    final theme = Theme.of(context);
    _show(
      context: context,
      message: message,
      icon: Icons.info,
      backgroundColor: theme.colorScheme.primary,
      duration: duration,
      onActionPressed: onActionPressed,
      actionLabel: actionLabel,
    );
  }

  /// Show a warning snackbar
  static void warning({
    required BuildContext context,
    required String message,
    Duration? duration,
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) {
    _show(
      context: context,
      message: message,
      icon: Icons.warning,
      backgroundColor: Colors.orange,
      duration: duration,
      onActionPressed: onActionPressed,
      actionLabel: actionLabel,
    );
  }

  static void _show({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color backgroundColor,
    Duration? duration,
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: onActionPressed != null && actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onActionPressed,
              )
            : null,
      ),
    );
  }
}

/// A modern tooltip widget with customizable styling
/// 
/// Usage:
/// ```dart
/// PlumerTooltip(
///   message: 'This is a tooltip',
///   child: IconButton(
///     icon: Icon(Icons.help_outline),
///     onPressed: () {},
///   ),
/// )
/// ```
class PlumerTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final PlumerTooltipPosition position;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const PlumerTooltip({
    super.key,
    required this.message,
    required this.child,
    this.position = PlumerTooltipPosition.top,
    this.backgroundColor,
    this.textStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Tooltip(
      message: message,
      preferBelow: position == PlumerTooltipPosition.bottom,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(6),
      ),
      textStyle: textStyle ??
          theme.textTheme.bodySmall?.copyWith(
            color: Colors.white,
          ),
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: child,
    );
  }
}

enum PlumerTooltipPosition {
  top,
  bottom,
}