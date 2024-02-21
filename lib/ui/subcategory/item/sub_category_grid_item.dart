import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/viewobject/sub_category.dart';

class SubCategoryGridItem extends StatefulWidget {
  const SubCategoryGridItem(
      {Key? key,
      required this.subCategory,
      this.onTap,
      this.animationController,
      this.animation,
      required this.subScribeNoti,
      required this.tempList})
      : super(key: key);

  final SubCategory subCategory;
  final Function? onTap;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final List<String?> tempList;
  final bool subScribeNoti;

  @override
  State<SubCategoryGridItem> createState() => _SubCategoryGridItemState();
}

class _SubCategoryGridItemState extends State<SubCategoryGridItem> {
  @override
  Widget build(BuildContext context) {
    widget.animationController!.forward();
    return AnimatedBuilder(
        animation: widget.animationController!,
        child: InkWell(
          onTap: widget.onTap as void Function()?,
          child: Stack(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: PsDimens.space4, vertical: PsDimens.space8),
                child: Container(
                  decoration: BoxDecoration(
                    color: PsColors.cardBackgroundColor,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(PsDimens.space16)),
                  ),
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
                              defaultIcon: widget.subCategory.defaultIcon,
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
                              widget.subCategory.name ?? '',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: PsColors.textColor1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: widget.subScribeNoti,
                child: Positioned(
                  top: 1,
                  right: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      color: PsColors.iconColor,
                      child: Icon(
                        Icons.circle,
                        color: widget.tempList
                                    .contains(widget.subCategory.id)
                            ? PsColors.iconColor
                            : PsColors.baseColor,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        builder: (BuildContext context, Widget? child) {
          return FadeTransition(
            opacity: widget.animation!,
            child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 100 * (1.0 - widget.animation!.value), 0.0),
                child: child),
          );
        });
  }
}
