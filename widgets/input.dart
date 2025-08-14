import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A modern, customizable text input widget with validation and theming
/// 
/// Usage:
/// ```dart
/// PlumerInput(
///   label: 'Email',
///   hint: 'Enter your email address',
///   prefixIcon: Icons.email,
///   validator: (value) => value?.isEmpty == true ? 'Email is required' : null,
///   onChanged: (value) => print('Input changed: $value'),
/// )
/// ```
class PlumerInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final Widget? prefix;
  final IconData? suffixIcon;
  final Widget? suffix;
  final VoidCallback? onSuffixIconTap;
  final PlumerInputVariant variant;
  final PlumerInputSize size;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  const PlumerInput({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.onChanged,
    this.onTap,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.suffix,
    this.onSuffixIconTap,
    this.variant = PlumerInputVariant.outlined,
    this.size = PlumerInputSize.medium,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.inputFormatters,
    this.focusNode,
  });

  @override
  State<PlumerInput> createState() => _PlumerInputState();
}

class _PlumerInputState extends State<PlumerInput> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.obscureText;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = widget.errorText != null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: hasError
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: _getInputHeight(),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? _getBackgroundColor(theme),
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            border: Border.all(
              color: _getBorderColor(theme, hasError),
              width: _isFocused ? 2.0 : 1.0,
            ),
            boxShadow: _isFocused && !hasError
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: _obscureText,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: widget.enabled
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withOpacity(0.38),
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: _getHorizontalPadding(),
                vertical: _getVerticalPadding(),
              ),
              border: InputBorder.none,
              prefixIcon: _buildPrefixIcon(theme),
              prefix: widget.prefix,
              suffixIcon: _buildSuffixIcon(theme),
              suffix: widget.suffix,
              counterText: '',
            ),
          ),
        ),
        if (widget.helperText != null || widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText ?? widget.helperText ?? '',
            style: theme.textTheme.bodySmall?.copyWith(
              color: hasError
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ],
    );
  }

  Widget? _buildPrefixIcon(ThemeData theme) {
    if (widget.prefixIcon != null) {
      return Icon(
        widget.prefixIcon,
        color: _isFocused
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface.withOpacity(0.6),
        size: _getIconSize(),
      );
    }
    return null;
  }

  Widget? _buildSuffixIcon(ThemeData theme) {
    if (widget.obscureText) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        child: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          size: _getIconSize(),
        ),
      );
    } else if (widget.suffixIcon != null) {
      return GestureDetector(
        onTap: widget.onSuffixIconTap,
        child: Icon(
          widget.suffixIcon,
          color: _isFocused
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withOpacity(0.6),
          size: _getIconSize(),
        ),
      );
    }
    return null;
  }

  Color _getBackgroundColor(ThemeData theme) {
    switch (widget.variant) {
      case PlumerInputVariant.filled:
        return theme.colorScheme.surfaceVariant;
      case PlumerInputVariant.outlined:
        return theme.colorScheme.surface;
    }
  }

  Color _getBorderColor(ThemeData theme, bool hasError) {
    if (hasError) return theme.colorScheme.error;
    if (_isFocused) {
      return widget.focusedBorderColor ?? theme.colorScheme.primary;
    }
    return widget.borderColor ?? theme.colorScheme.outline;
  }

  double _getInputHeight() {
    switch (widget.size) {
      case PlumerInputSize.small:
        return 40.0;
      case PlumerInputSize.medium:
        return 48.0;
      case PlumerInputSize.large:
        return 56.0;
    }
  }

  double _getHorizontalPadding() {
    switch (widget.size) {
      case PlumerInputSize.small:
        return 12.0;
      case PlumerInputSize.medium:
        return 16.0;
      case PlumerInputSize.large:
        return 20.0;
    }
  }

  double _getVerticalPadding() {
    switch (widget.size) {
      case PlumerInputSize.small:
        return 8.0;
      case PlumerInputSize.medium:
        return 12.0;
      case PlumerInputSize.large:
        return 16.0;
    }
  }

  double _getBorderRadius() {
    return 8.0;
  }

  double _getIconSize() {
    switch (widget.size) {
      case PlumerInputSize.small:
        return 18.0;
      case PlumerInputSize.medium:
        return 20.0;
      case PlumerInputSize.large:
        return 24.0;
    }
  }
}

enum PlumerInputVariant {
  filled,
  outlined,
}

enum PlumerInputSize {
  small,
  medium,
  large,
}

/// A modern search input widget with debouncing
/// 
/// Usage:
/// ```dart
/// PlumerSearchInput(
///   onSearch: (query) => print('Search: $query'),
///   placeholder: 'Search products...',
/// )
/// ```
class PlumerSearchInput extends StatefulWidget {
  final ValueChanged<String>? onSearch;
  final String? placeholder;
  final Duration debounceTime;
  final IconData? prefixIcon;
  final bool showClearButton;
  final Color? backgroundColor;

  const PlumerSearchInput({
    super.key,
    this.onSearch,
    this.placeholder,
    this.debounceTime = const Duration(milliseconds: 300),
    this.prefixIcon,
    this.showClearButton = true,
    this.backgroundColor,
  });

  @override
  State<PlumerSearchInput> createState() => _PlumerSearchInputState();
}

class _PlumerSearchInputState extends State<PlumerSearchInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    setState(() {
      _showClearButton = text.isNotEmpty;
    });

    _debounceTimer?.cancel();
    if (text.isNotEmpty) {
      _debounceTimer = Timer(widget.debounceTime, () {
        widget.onSearch?.call(text);
      });
    } else {
      widget.onSearch?.call('');
    }
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _clearSearch() {
    _controller.clear();
    widget.onSearch?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _focusNode.hasFocus
              ? theme.colorScheme.primary
              : Colors.transparent,
          width: 2.0,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Icon(
              widget.prefixIcon ?? Icons.search,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              size: 20,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: widget.placeholder ?? 'Search...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          if (_showClearButton && widget.showClearButton)
            GestureDetector(
              onTap: _clearSearch,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.clear,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A modern dropdown selector widget
/// 
/// Usage:
/// ```dart
/// PlumerDropdown<String>(
///   label: 'Country',
///   value: selectedCountry,
///   items: countries,
///   onChanged: (value) => setState(() => selectedCountry = value),
///   itemBuilder: (item) => Text(item),
/// )
/// ```
class PlumerDropdown<T> extends StatefulWidget {
  final String? label;
  final T? value;
  final List<T> items;
  final ValueChanged<T?>? onChanged;
  final Widget Function(T) itemBuilder;
  final String? hint;
  final IconData? prefixIcon;
  final bool enabled;
  final PlumerInputSize size;

  const PlumerDropdown({
    super.key,
    this.label,
    this.value,
    required this.items,
    this.onChanged,
    required this.itemBuilder,
    this.hint,
    this.prefixIcon,
    this.enabled = true,
    this.size = PlumerInputSize.medium,
  });

  @override
  State<PlumerDropdown<T>> createState() => _PlumerDropdownState<T>();
}

class _PlumerDropdownState<T> extends State<PlumerDropdown<T>> {
  bool _isOpen = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (!widget.enabled) return;
    
    setState(() {
      _isOpen = true;
    });

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    setState(() {
      _isOpen = false;
    });

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final theme = Theme.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            color: theme.colorScheme.surface,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.outline,
                ),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  final isSelected = item == widget.value;

                  return InkWell(
                    onTap: () {
                      widget.onChanged?.call(item);
                      _closeDropdown();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primary.withOpacity(0.1)
                            : null,
                      ),
                      child: Row(
                        children: [
                          Expanded(child: widget.itemBuilder(item)),
                          if (isSelected)
                            Icon(
                              Icons.check,
                              color: theme.colorScheme.primary,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              height: _getInputHeight(),
              padding: EdgeInsets.symmetric(
                horizontal: _getHorizontalPadding(),
                vertical: _getVerticalPadding(),
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isOpen
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                  width: _isOpen ? 2.0 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  if (widget.prefixIcon != null) ...[
                    Icon(
                      widget.prefixIcon,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      size: _getIconSize(),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: widget.value != null
                        ? widget.itemBuilder(widget.value!)
                        : Text(
                            widget.hint ?? 'Select an option',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                  ),
                  AnimatedRotation(
                    turns: _isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      size: _getIconSize(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _getInputHeight() {
    switch (widget.size) {
      case PlumerInputSize.small:
        return 40.0;
      case PlumerInputSize.medium:
        return 48.0;
      case PlumerInputSize.large:
        return 56.0;
    }
  }

  double _getHorizontalPadding() {
    switch (widget.size) {
      case PlumerInputSize.small:
        return 12.0;
      case PlumerInputSize.medium:
        return 16.0;
      case PlumerInputSize.large:
        return 20.0;
    }
  }

  double _getVerticalPadding() {
    switch (widget.size) {
      case PlumerInputSize.small:
        return 8.0;
      case PlumerInputSize.medium:
        return 12.0;
      case PlumerInputSize.large:
        return 16.0;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case PlumerInputSize.small:
        return 18.0;
      case PlumerInputSize.medium:
        return 20.0;
      case PlumerInputSize.large:
        return 24.0;
    }
  }
}

/// A modern checkbox widget with custom styling
/// 
/// Usage:
/// ```dart
/// PlumerCheckbox(
///   value: isChecked,
///   onChanged: (value) => setState(() => isChecked = value ?? false),
///   label: 'I agree to the terms and conditions',
/// )
/// ```
class PlumerCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final Color? activeColor;
  final Color? checkColor;
  final PlumerCheckboxSize size;

  const PlumerCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.activeColor,
    this.checkColor,
    this.size = PlumerCheckboxSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final checkboxSize = _getCheckboxSize();
    
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: checkboxSize,
            height: checkboxSize,
            decoration: BoxDecoration(
              color: value
                  ? (activeColor ?? theme.colorScheme.primary)
                  : Colors.transparent,
              border: Border.all(
                color: value
                    ? (activeColor ?? theme.colorScheme.primary)
                    : theme.colorScheme.outline,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: value
                ? Icon(
                    Icons.check,
                    color: checkColor ?? theme.colorScheme.onPrimary,
                    size: checkboxSize * 0.6,
                  )
                : null,
          ),
          if (label != null) ...[
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                label!,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }

  double _getCheckboxSize() {
    switch (size) {
      case PlumerCheckboxSize.small:
        return 16.0;
      case PlumerCheckboxSize.medium:
        return 20.0;
      case PlumerCheckboxSize.large:
        return 24.0;
    }
  }
}

enum PlumerCheckboxSize {
  small,
  medium,
  large,
}

import 'dart:async';