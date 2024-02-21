

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/viewobject/category.dart';

class CategoryVerticalListItem extends StatelessWidget {
  const CategoryVerticalListItem(
      {Key? key,
      required this.category,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final Category category;

  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    animationController!.forward();
    return AnimatedBuilder(
        animation: animationController!,
        child: InkWell(
        onTap: onTap as void Function()?,
        child: Container(
         margin: const EdgeInsets.symmetric(
        horizontal: PsDimens.space4, vertical: PsDimens.space8),
          child: Container(       
            decoration: BoxDecoration(
                color: PsColors.cardBackgroundColor,
                borderRadius:
                    const BorderRadius.all(Radius.circular(PsDimens.space16)),
              ),
           // width: PsDimens.space80,
           // height: PsDimens.space80,
            child: Ink(
              color: PsColors.backgroundColor,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: PsDimens.space48,
                      height: PsDimens.space44,
                      child: PsNetworkCircleIconImage(
                        photoKey: '',
                        defaultIcon: category.defaultIcon,
                        // width: PsDimens.space52,
                        // height: PsDimens.space52,
                        boxfit: BoxFit.fitHeight,
                      ),
                    ),
                    const SizedBox(
                      height: PsDimens.space6,
                    ),
                    Flexible(
                      child: Text(
                        category.catName!,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontWeight: FontWeight.bold,color:PsColors.textColor1 ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        ),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: animation!,
            child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - animation!.value), 0.0),
                child: child),
          );
        });
  }
}
