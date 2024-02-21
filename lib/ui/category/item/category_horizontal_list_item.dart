

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/viewobject/category.dart';

class CategoryHorizontalListItem extends StatelessWidget {
  const CategoryHorizontalListItem({
    Key? key,
    required this.category,
    this.onTap,
  }) : super(key: key);

  final Category category;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
            width: PsDimens.space80,
            height: PsDimens.space80,
            child: Ink(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: PsDimens.space40,
                    height: PsDimens.space32,
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
                          .copyWith(fontWeight: FontWeight.bold,color:PsColors.textColor1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        );
  }
}
