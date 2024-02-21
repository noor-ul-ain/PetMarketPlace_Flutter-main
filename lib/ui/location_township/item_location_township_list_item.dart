

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';

class ItemLocationTownshipListItem extends StatelessWidget {
  const ItemLocationTownshipListItem(
      {Key? key,
      required this.itemLocationTownship,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final String? itemLocationTownship;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: InkWell(
          highlightColor: PsColors.primary50,
            onTap: onTap as void Function()?,
            child: Container(
                margin: const EdgeInsets.only(bottom: PsDimens.space8),
                child: Ink(
                    child: ItemLocationTownshipListItemWidget(
                        itemLocationTownship: itemLocationTownship)))),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
              opacity: animation!,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation!.value), 0.0),
                  child: child));
        });
  }
}

class ItemLocationTownshipListItemWidget extends StatelessWidget {
  const ItemLocationTownshipListItemWidget({
    Key? key,
    required this.itemLocationTownship,
  }) : super(key: key);

  final String? itemLocationTownship;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(PsDimens.space16),
      child: Text(
        itemLocationTownship!,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
