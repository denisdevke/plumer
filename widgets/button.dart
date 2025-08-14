import 'package:flutter/material.dart';

/// A modern, customizable button widget with various styles and animations
/// 
/// Usage:
/// ```dart
/// PlumerButton(
///   text: 'Get Started',
///   onPressed: () => print('Button pressed'),
///   variant: PlumerButtonVariant.primary,
///   size: PlumerButtonSize.large,
///   icon: Icons.rocket_launch,
/// )
/// ```
class PlumerButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final PlumerButtonVariant variant;
  final PlumerButtonSize size;
  final IconData? icon;
  final IconData? suffixIcon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double? elevation;
  final TextStyle? textStyle;

  const PlumerButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = PlumerButtonVariant.primary,
    this.size = PlumerButtonSize.medium,
    this.icon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.elevation,
    this.textStyle,
  });

  @override
  State<PlumerButton> createState() => _PlumerButtonState();
}

class _PlumerButtonState extends State<PlumerButton>
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
      end: 0.95,
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
    final isDisabled = widget.onPressed == null || widget.isLoading;
    
    // Get button configuration based on variant
    final config = _getButtonConfig(theme);
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SizedBox(
            width: widget.isFullWidth ? double.infinity : null,
            height: _getButtonHeight(),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isDisabled ? null : widget.onPressed,
                onTapDown: isDisabled ? null : (_) => _onTapDown(),
                onTapUp: isDisabled ? null : (_) => _onTapUp(),
                onTapCancel: isDisabled ? null : _onTapCancel,
                borderRadius: widget.borderRadius ?? _getDefaultBorderRadius(),
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ?? config.backgroundColor,
                    borderRadius: widget.borderRadius ?? _getDefaultBorderRadius(),
                    border: config.borderColor != null
                        ? Border.all(
                            color: widget.borderColor ?? config.borderColor!,
                            width: 1.5,
                          )
                        : null,
                    boxShadow: widget.elevation != null || config.elevation > 0
                        ? [
                            BoxShadow(
                              color: (widget.backgroundColor ?? config.backgroundColor)
                                  .withOpacity(0.3),
                              blurRadius: widget.elevation ?? config.elevation,
                              offset: Offset(0, (widget.elevation ?? config.elevation) / 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Padding(
                    padding: widget.padding ?? _getDefaultPadding(),
                    child: Row(
                      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.isLoading) ...[
                          SizedBox(
                            width: _getIconSize(),
                            height: _getIconSize(),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.foregroundColor ?? config.foregroundColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ] else if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            size: _getIconSize(),
                            color: widget.foregroundColor ?? config.foregroundColor,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Flexible(
                          child: Text(
                            widget.text,
                            style: widget.textStyle ?? _getDefaultTextStyle(theme, config),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.suffixIcon != null) ...[
                          const SizedBox(width: 8),
                          Icon(
                            widget.suffixIcon,
                            size: _getIconSize(),
                            color: widget.foregroundColor ?? config.foregroundColor,
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

  _ButtonConfig _getButtonConfig(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    
    switch (widget.variant) {
      case PlumerButtonVariant.primary:
        return _ButtonConfig(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2.0,
        );
      
      case PlumerButtonVariant.secondary:
        return _ButtonConfig(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          elevation: 1.0,
        );
      
      case PlumerButtonVariant.outline:
        return _ButtonConfig(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.primary,
          borderColor: colorScheme.primary,
          elevation: 0.0,
        );
      
      case PlumerButtonVariant.ghost:
        return _ButtonConfig(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.primary,
          elevation: 0.0,
        );
      
      case PlumerButtonVariant.destructive:
        return _ButtonConfig(
          backgroundColor: colorScheme.error,
          foregroundColor: colorScheme.onError,
          elevation: 2.0,
        );
      
      case PlumerButtonVariant.success:
        return _ButtonConfig(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 2.0,
        );
    }
  }

  double _getButtonHeight() {
    switch (widget.size) {
      case PlumerButtonSize.small:
        return 36.0;
      case PlumerButtonSize.medium:
        return 44.0;
      case PlumerButtonSize.large:
        return 52.0;
    }
  }

  EdgeInsetsGeometry _getDefaultPadding() {
    switch (widget.size) {
      case PlumerButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case PlumerButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      case PlumerButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
    }
  }

  BorderRadius _getDefaultBorderRadius() {
    return BorderRadius.circular(8.0);
  }

  double _getIconSize() {
    switch (widget.size) {
      case PlumerButtonSize.small:
        return 16.0;
      case PlumerButtonSize.medium:
        return 18.0;
      case PlumerButtonSize.large:
        return 20.0;
    }
  }

  TextStyle _getDefaultTextStyle(ThemeData theme, _ButtonConfig config) {
    final baseStyle = switch (widget.size) {
      PlumerButtonSize.small => theme.textTheme.labelMedium,
      PlumerButtonSize.medium => theme.textTheme.labelLarge,
      PlumerButtonSize.large => theme.textTheme.titleMedium,
    };

    return baseStyle?.copyWith(
      color: widget.foregroundColor ?? config.foregroundColor,
      fontWeight: FontWeight.w600,
    ) ?? TextStyle(
      color: widget.foregroundColor ?? config.foregroundColor,
      fontWeight: FontWeight.w600,
    );
  }
}

/// Button variant enum defining different visual styles
enum PlumerButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  destructive,
  success,
}

/// Button size enum defining different sizes
enum PlumerButtonSize {
  small,
  medium,
  large,
}

/// Internal configuration class for button styling
class _ButtonConfig {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final double elevation;

  _ButtonConfig({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
    required this.elevation,
  });
}

/// A floating action button with modern styling
/// 
/// Usage:
/// ```dart
/// PlumerFAB(
///   onPressed: () => print('FAB pressed'),
///   icon: Icons.add,
///   heroTag: 'main_fab',
/// )
/// ```
class PlumerFAB extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? heroTag;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PlumerFABSize size;
  final String? tooltip;

  const PlumerFAB({
    super.key,
    required this.onPressed,
    required this.icon,
    this.heroTag,
    this.backgroundColor,
    this.foregroundColor,
    this.size = PlumerFABSize.regular,
    this.tooltip,
  });

  @override
  State<PlumerFAB> createState() => _PlumerFABState();
}

class _PlumerFABState extends State<PlumerFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
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
    final size = _getFABSize();
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(size / 2),
              boxShadow: [
                BoxShadow(
                  color: (widget.backgroundColor ?? theme.colorScheme.primary)
                      .withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                onTapDown: (_) => _animationController.forward(),
                onTapUp: (_) => _animationController.reverse(),
                onTapCancel: () => _animationController.reverse(),
                borderRadius: BorderRadius.circular(size / 2),
                child: Icon(
                  widget.icon,
                  color: widget.foregroundColor ?? theme.colorScheme.onPrimary,
                  size: _getIconSize(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _getFABSize() {
    switch (widget.size) {
      case PlumerFABSize.mini:
        return 40.0;
      case PlumerFABSize.regular:
        return 56.0;
      case PlumerFABSize.large:
        return 72.0;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case PlumerFABSize.mini:
        return 18.0;
      case PlumerFABSize.regular:
        return 24.0;
      case PlumerFABSize.large:
        return 32.0;
    }
  }
}

enum PlumerFABSize {
  mini,
  regular,
  large,
}

/// A modern icon button with customizable styling
/// 
/// Usage:
/// ```dart
/// PlumerIconButton(
///   icon: Icons.favorite,
///   onPressed: () => print('Icon button pressed'),
///   variant: PlumerIconButtonVariant.filled,
/// )
/// ```
class PlumerIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final PlumerIconButtonVariant variant;
  final PlumerIconButtonSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;

  const PlumerIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = PlumerIconButtonVariant.standard,
    this.size = PlumerIconButtonSize.medium,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
  });

  @override
  State<PlumerIconButton> createState() => _PlumerIconButtonState();
}

class _PlumerIconButtonState extends State<PlumerIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = _getIconButtonConfig(theme);
    final size = _getButtonSize();
    
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? config.backgroundColor,
          borderRadius: BorderRadius.circular(size / 2),
          border: config.borderColor != null
              ? Border.all(color: config.borderColor!, width: 1.5)
              : null,
          boxShadow: _isPressed ? null : config.boxShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(size / 2),
            child: Icon(
              widget.icon,
              color: widget.foregroundColor ?? config.foregroundColor,
              size: _getIconSize(),
            ),
          ),
        ),
      ),
    );
  }

  _IconButtonConfig _getIconButtonConfig(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    
    switch (widget.variant) {
      case PlumerIconButtonVariant.standard:
        return _IconButtonConfig(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.onSurface,
        );
      
      case PlumerIconButtonVariant.filled:
        return _IconButtonConfig(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        );
      
      case PlumerIconButtonVariant.outlined:
        return _IconButtonConfig(
          backgroundColor: Colors.transparent,
          foregroundColor: colorScheme.primary,
          borderColor: colorScheme.primary,
        );
    }
  }

  double _getButtonSize() {
    switch (widget.size) {
      case PlumerIconButtonSize.small:
        return 32.0;
      case PlumerIconButtonSize.medium:
        return 40.0;
      case PlumerIconButtonSize.large:
        return 48.0;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case PlumerIconButtonSize.small:
        return 16.0;
      case PlumerIconButtonSize.medium:
        return 20.0;
      case PlumerIconButtonSize.large:
        return 24.0;
    }
  }
}

enum PlumerIconButtonVariant {
  standard,
  filled,
  outlined,
}

enum PlumerIconButtonSize {
  small,
  medium,
  large,
}

class _IconButtonConfig {
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;

  _IconButtonConfig({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
    this.boxShadow,
  });
}