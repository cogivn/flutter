import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A sliver that fills the remaining space in the viewport.
///
/// This widget is useful for creating a footer that fills the available space
/// at the bottom of a scrollable area while ensuring it doesn't get cut off.
class SliverFooter extends SingleChildRenderObjectWidget {
  /// Creates a sliver that fills the remaining space in the viewport.
  ///
  /// The [child] widget is rendered within the available space.
  const SliverFooter({super.key, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverFooter();
  }
}

/// The render object for [SliverFooter] that handles layout and painting.
class RenderSliverFooter extends RenderSliverSingleBoxAdapter {
  /// Creates a [RenderSliver] that wraps a [RenderBox] which is sized to fit
  /// the remaining space in the viewport.
  RenderSliverFooter({super.child});

  // Constant for maximum extent value
  static const double _kMaxExtent = double.infinity;

  @override
  void performLayout() {
    // Calculate available space
    double extent = _calculateAvailableExtent();

    if (child != null) {
      // Adjust extent based on child size constraints
      extent = _layoutChildAndAdjustExtent(extent);
    }

    // Set the final geometry
    _setGeometryWithExtent(extent);
  }

  /// Calculates the available extent in the viewport
  double _calculateAvailableExtent() {
    // The remaining space in the viewportMainAxisExtent
    // Can be <= 0 if we have scrolled beyond the extent of the screen
    return constraints.viewportMainAxisExtent - constraints.precedingScrollExtent;
  }

  /// Layouts child and adjusts the extent if necessary
  double _layoutChildAndAdjustExtent(double extent) {
    assert(child != null, 'Child should not be null when this method is called');

    // Calculate the child's intrinsic extent
    final double childExtent = _calculateChildExtent();

    // Use the larger of calculated extent and child's intrinsic extent
    // This prevents cutting off the child if it's larger than available space
    extent = math.max(extent, childExtent);

    // Layout the child with the adjusted extent
    child!.layout(constraints.asBoxConstraints(
      minExtent: extent,
      maxExtent: _kMaxExtent,
    ));

    return extent;
  }

  /// Calculates the child's intrinsic extent based on the constraint axis
  double _calculateChildExtent() {
    assert(child != null, 'Child should not be null when this method is called');

    switch (constraints.axis) {
      case Axis.horizontal:
        return child!.getMaxIntrinsicWidth(constraints.crossAxisExtent);
      case Axis.vertical:
        return child!.getMaxIntrinsicHeight(constraints.crossAxisExtent);
    }
  }

  /// Sets the final geometry for the sliver based on the calculated extent
  void _setGeometryWithExtent(double extent) {
    final paintedChildSize = calculatePaintOffset(
      constraints,
      from: 0.0,
      to: extent,
    );

    assert(
      paintedChildSize.isFinite,
      'Painted child size must be finite',
    );
    assert(
      paintedChildSize >= 0.0,
      'Painted child size must not be negative',
    );

    geometry = SliverGeometry(
      scrollExtent: extent,
      paintExtent: paintedChildSize,
      maxPaintExtent: paintedChildSize,
      hasVisualOverflow: extent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );

    if (child != null) {
      setChildParentData(child!, constraints, geometry!);
    }
  }
}
