import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eu_faco_parte/app/core/ui/widgets/custom_drawer.dart';

import '../../../colors/services/theme_service.dart';
import 'background_wave.dart';

class SliverSearchAppBar extends SliverPersistentHeaderDelegate {
  const SliverSearchAppBar();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var adjustedShrinkOffset =
        shrinkOffset > minExtent ? minExtent : shrinkOffset;
    double offset = (minExtent - adjustedShrinkOffset) * 0.5;
    double topPadding = MediaQuery.of(context).padding.top + 16;

    return Stack(
      children: [
        const BackgroundWave(
          height: 280,
        ),
        Positioned(
          top: topPadding + offset,
          left: 16,
          right: 16,
          child: Row(
            children: [
              Expanded(
                child: Image.asset(
                  'assets/images/header.png',
                  fit: BoxFit.contain,
                  height: 80,
                ),
              ),
              IconButton(
                onPressed: ThemeService().switchTheme,
                icon: const Icon(Icons.contrast),
                color: Get.theme.colorScheme.onBackground,
                iconSize: 30,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.menu),
                color: Get.theme.colorScheme.onBackground,
                iconSize: 30,
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  double get maxExtent => 280;

  @override
  double get minExtent => 140;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      oldDelegate.maxExtent != maxExtent || oldDelegate.minExtent != minExtent;
}
