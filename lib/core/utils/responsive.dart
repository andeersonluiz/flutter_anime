import 'package:flutter/widgets.dart';

/// Responsive layout utilities.
///
/// Replaces hardcoded values like `crossAxisCount: 4` and `childAspectRatio: 0.57`
/// scattered across grids and lists.
class Responsive {
  Responsive._();

  static const double _phoneBreakpoint = 600;
  static const double _tabletBreakpoint = 900;

  /// Number of columns for anime/character grids.
  static int gridColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width > _tabletBreakpoint) return 5;
    if (width > _phoneBreakpoint) return 4;
    return 3;
  }

  /// Aspect ratio for anime poster cards.
  static double animeCardAspectRatio(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width > _phoneBreakpoint) return 0.65;
    return 0.57;
  }

  /// Number of columns for character grids.
  static int characterGridColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width > _tabletBreakpoint) return 6;
    if (width > _phoneBreakpoint) return 5;
    return 4;
  }

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width > _phoneBreakpoint;
}
