import 'package:flutter/material.dart';

/// A modern bottom navigation bar with customizable styling and animations
/// 
/// Usage:
/// ```dart
/// PlumerBottomNav(
///   currentIndex: _selectedIndex,
///   onTap: (index) => setState(() => _selectedIndex = index),
///   items: [
///     PlumerBottomNavItem(
///       icon: Icons.home,
///       label: 'Home',
///     ),
///     PlumerBottomNavItem(
///       icon: Icons.search,
///       label: 'Search',
///     ),
///   ],
/// )
/// ```
class PlumerBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final List<PlumerBottomNavItem> items;
  final PlumerBottomNavStyle style;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double elevation;
  final double height;
  final bool showLabels;
  final EdgeInsetsGeometry? padding;

  const PlumerBottomNav({
    super.key,
    required this.currentIndex,
    this.onTap,
    required this.items,
    this.style = PlumerBottomNavStyle.fixed,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8.0,
    this.height = 70.0,
    this.showLabels = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = selectedItemColor ?? theme.colorScheme.primary;
    final unselectedColor = unselectedItemColor ?? theme.colorScheme.onSurface.withOpacity(0.6);
    final bgColor = backgroundColor ?? theme.colorScheme.surface;

    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: elevation,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == currentIndex;

          return _buildNavItem(
            context,
            item,
            isSelected,
            selectedColor,
            unselectedColor,
            () => onTap?.call(index),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    PlumerBottomNavItem item,
    bool isSelected,
    Color selectedColor,
    Color unselectedColor,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    
    switch (style) {
      case PlumerBottomNavStyle.fixed:
        return _buildFixedItem(theme, item, isSelected, selectedColor, unselectedColor, onTap);
      case PlumerBottomNavStyle.floating:
        return _buildFloatingItem(theme, item, isSelected, selectedColor, unselectedColor, onTap);
      case PlumerBottomNavStyle.minimal:
        return _buildMinimalItem(theme, item, isSelected, selectedColor, unselectedColor, onTap);
    }
  }

  Widget _buildFixedItem(
    ThemeData theme,
    PlumerBottomNavItem item,
    bool isSelected,
    Color selectedColor,
    Color unselectedColor,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? selectedColor.withOpacity(0.1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                  color: isSelected ? selectedColor : unselectedColor,
                  size: 24,
                ),
              ),
              if (showLabels) ...[
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSelected ? selectedColor : unselectedColor,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingItem(
    ThemeData theme,
    PlumerBottomNavItem item,
    bool isSelected,
    Color selectedColor,
    Color unselectedColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? (item.activeIcon ?? item.icon) : item.icon,
              color: isSelected ? theme.colorScheme.onPrimary : unselectedColor,
              size: 24,
            ),
            if (isSelected && showLabels) ...[
              const SizedBox(width: 8),
              Text(
                item.label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalItem(
    ThemeData theme,
    PlumerBottomNavItem item,
    bool isSelected,
    Color selectedColor,
    Color unselectedColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: 24,
            decoration: BoxDecoration(
              color: isSelected ? selectedColor : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          Icon(
            isSelected ? (item.activeIcon ?? item.icon) : item.icon,
            color: isSelected ? selectedColor : unselectedColor,
            size: 24,
          ),
          if (showLabels) ...[
            const SizedBox(height: 4),
            Text(
              item.label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isSelected ? selectedColor : unselectedColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Configuration for bottom navigation items
class PlumerBottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final Widget? badge;

  const PlumerBottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.badge,
  });
}

/// Bottom navigation bar styles
enum PlumerBottomNavStyle {
  fixed,
  floating,
  minimal,
}

/// A modern tab bar with customizable styling
/// 
/// Usage:
/// ```dart
/// PlumerTabBar(
///   tabs: ['Home', 'Profile', 'Settings'],
///   selectedIndex: _selectedTab,
///   onTap: (index) => setState(() => _selectedTab = index),
/// )
/// ```
class PlumerTabBar extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int>? onTap;
  final PlumerTabBarStyle style;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final double height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const PlumerTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    this.onTap,
    this.style = PlumerTabBarStyle.underline,
    this.selectedColor,
    this.unselectedColor,
    this.backgroundColor,
    this.indicatorColor,
    this.height = 48.0,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedCol = selectedColor ?? theme.colorScheme.primary;
    final unselectedCol = unselectedColor ?? theme.colorScheme.onSurface.withOpacity(0.6);
    final bgColor = backgroundColor ?? theme.colorScheme.surface;

    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == selectedIndex;

          return Expanded(
            child: _buildTab(context, tab, isSelected, selectedCol, unselectedCol, () => onTap?.call(index)),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    String tab,
    bool isSelected,
    Color selectedColor,
    Color unselectedColor,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    switch (style) {
      case PlumerTabBarStyle.underline:
        return _buildUnderlineTab(theme, tab, isSelected, selectedColor, unselectedColor, onTap);
      case PlumerTabBarStyle.pills:
        return _buildPillTab(theme, tab, isSelected, selectedColor, unselectedColor, onTap);
      case PlumerTabBarStyle.segmented:
        return _buildSegmentedTab(theme, tab, isSelected, selectedColor, unselectedColor, onTap);
    }
  }

  Widget _buildUnderlineTab(
    ThemeData theme,
    String tab,
    bool isSelected,
    Color selectedColor,
    Color unselectedColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? (indicatorColor ?? selectedColor) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          tab,
          style: theme.textTheme.labelLarge?.copyWith(
            color: isSelected ? selectedColor : unselectedColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPillTab(
    ThemeData theme,
    String tab,
    bool isSelected,
    Color selectedColor,
    Color unselectedColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            tab,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isSelected ? theme.colorScheme.onPrimary : unselectedColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedTab(
    ThemeData theme,
    String tab,
    bool isSelected,
    Color selectedColor,
    Color unselectedColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            tab,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isSelected ? theme.colorScheme.onPrimary : selectedColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// Tab bar styles
enum PlumerTabBarStyle {
  underline,
  pills,
  segmented,
}

/// A modern navigation drawer with sections and animations
/// 
/// Usage:
/// ```dart
/// PlumerDrawer(
///   header: PlumerDrawerHeader(
///     child: UserAccountsDrawerHeader(...),
///   ),
///   items: [
///     PlumerDrawerItem(
///       icon: Icons.home,
///       title: 'Home',
///       onTap: () => Navigator.pop(context),
///     ),
///   ],
/// )
/// ```
class PlumerDrawer extends StatelessWidget {
  final PlumerDrawerHeader? header;
  final List<PlumerDrawerItem> items;
  final Color? backgroundColor;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const PlumerDrawer({
    super.key,
    this.header,
    required this.items,
    this.backgroundColor,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: width ?? 280,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
      ),
      child: SafeArea(
        child: Column(
          children: [
            if (header != null) header!,
            Expanded(
              child: ListView(
                padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
                children: items.map((item) => _buildDrawerItem(context, item)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, PlumerDrawerItem item) {
    final theme = Theme.of(context);

    if (item.isDivider) {
      return Divider(
        color: theme.colorScheme.outline.withOpacity(0.2),
        height: 1,
        indent: 16,
        endIndent: 16,
      );
    }

    if (item.isHeader) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(
          item.title,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return ListTile(
      leading: item.icon != null
          ? Icon(
              item.icon,
              color: item.isSelected 
                  ? theme.colorScheme.primary 
                  : theme.colorScheme.onSurface.withOpacity(0.6),
            )
          : null,
      title: Text(
        item.title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: item.isSelected 
              ? theme.colorScheme.primary 
              : theme.colorScheme.onSurface,
          fontWeight: item.isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      trailing: item.trailing,
      selected: item.isSelected,
      selectedTileColor: theme.colorScheme.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: item.onTap,
    );
  }
}

/// Configuration for drawer header
class PlumerDrawerHeader extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double height;

  const PlumerDrawerHeader({
    super.key,
    required this.child,
    this.backgroundColor,
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.primaryContainer,
      ),
      child: child,
    );
  }
}

/// Configuration for drawer items
class PlumerDrawerItem {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isDivider;
  final bool isHeader;

  const PlumerDrawerItem({
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    this.isSelected = false,
    this.isDivider = false,
    this.isHeader = false,
  });

  /// Creates a divider item
  const PlumerDrawerItem.divider()
      : title = '',
        subtitle = null,
        icon = null,
        trailing = null,
        onTap = null,
        isSelected = false,
        isDivider = true,
        isHeader = false;

  /// Creates a header item
  const PlumerDrawerItem.header(this.title)
      : subtitle = null,
        icon = null,
        trailing = null,
        onTap = null,
        isSelected = false,
        isDivider = false,
        isHeader = true;
}