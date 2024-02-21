

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/viewobject/category.dart';

class CategoryHorizontalTrendingListItem extends StatelessWidget {
  const CategoryHorizontalTrendingListItem(
      {Key? key,
      required this.category,
      this.onTap,
      required this.animationController,
      required this.animation})
      : super(key: key);

  final Category category;

  final Function? onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        child: InkWell(
            onTap: onTap as void Function()?,
            child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: PsDimens.space8, vertical: PsDimens.space8),
                decoration: BoxDecoration(
                  color: PsColors.backgroundColor,
                  borderRadius:
                      const BorderRadius.all(Radius.circular(PsDimens.space8)),
                ),
                child: Ink(
                  color: PsColors.backgroundColor,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              child: PsNetworkImage(
                                  photoKey: '',
                                  defaultPhoto: category.defaultPhoto,
                                  width: PsDimens.space200,
                                  height: double.infinity,
                                  boxfit: BoxFit.cover,
                                  imageAspectRation: PsConst.Aspect_Ratio_1x,
                                  onTap: onTap),
                            ),
                            Container(
                                width: 200,
                                height: double.infinity,
                                color: PsColors.black.withAlpha(110)),
                          ],
                        ),
                      ),
                      Text(
                        category.catName!,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: PsColors.white, fontWeight: FontWeight.bold),
                      ),
                      Container(
                          child: Positioned(
                        bottom: 10,
                        left: 10,
                        child: PsNetworkCircleIconImage(
                            photoKey: '',
                            defaultIcon: category.defaultIcon,
                            width: PsDimens.space40,
                            height: PsDimens.space40,
                            boxfit: BoxFit.cover,
                            onTap: onTap),
                      )),
                    ],
                  ),
                ))),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation.value), 0.0),
                child: child),
          );
        });
  }
}
