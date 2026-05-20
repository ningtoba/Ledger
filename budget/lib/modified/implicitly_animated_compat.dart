// Minimal compatibility shim for removed implicitly_animated_reorderable_list package.
// This provides stubs that fall back to standard Flutter widgets so the app can
// still compile and function while using the same API surface.
// Replace these with proper implementations in a future refactor.

import 'package:flutter/material.dart';

class ImplicitlyAnimatedList<T> extends StatelessWidget {
  final bool spawnIsolate;
  final List<T> items;
  final bool Function(T, T) areItemsTheSame;
  final Duration insertDuration;
  final Duration removeDuration;
  final Duration updateDuration;
  final Widget Function(BuildContext, Animation<double>, T, int) itemBuilder;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const ImplicitlyAnimatedList({
    super.key,
    this.spawnIsolate = true,
    required this.items,
    required this.areItemsTheSame,
    this.insertDuration = const Duration(milliseconds: 300),
    this.removeDuration = const Duration(milliseconds: 300),
    this.updateDuration = const Duration(milliseconds: 300),
    required this.itemBuilder,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: physics,
      shrinkWrap: shrinkWrap,
      children: List.generate(items.length, (index) {
        return itemBuilder(context, AlwaysStoppedAnimation(1.0), items[index], index);
      }),
    );
  }
}

class SliverImplicitlyAnimatedList<T> extends StatelessWidget {
  final bool spawnIsolate;
  final List<T> items;
  final bool Function(T, T) areItemsTheSame;
  final Duration insertDuration;
  final Duration removeDuration;
  final Duration updateDuration;
  final Widget Function(BuildContext, Animation<double>, T, int) itemBuilder;

  const SliverImplicitlyAnimatedList({
    super.key,
    this.spawnIsolate = true,
    required this.items,
    required this.areItemsTheSame,
    this.insertDuration = const Duration(milliseconds: 300),
    this.removeDuration = const Duration(milliseconds: 300),
    this.updateDuration = const Duration(milliseconds: 300),
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return itemBuilder(context, AlwaysStoppedAnimation(1.0), items[index], index);
        },
        childCount: items.length,
      ),
    );
  }
}

class SizeFadeTransition extends StatelessWidget {
  final double sizeFraction;
  final Curve curve;
  final Animation<double> animation;
  final Widget child;

  const SizeFadeTransition({
    super.key,
    this.sizeFraction = 0.7,
    this.curve = Curves.easeInOut,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
