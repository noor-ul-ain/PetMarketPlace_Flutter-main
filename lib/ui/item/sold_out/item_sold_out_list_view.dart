import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';

class ItemSoldOutListViewItem extends StatelessWidget {
  const ItemSoldOutListViewItem(
      {Key? key,
      required this.product,
      this.onTap,
      required this.animationController,
      required this.animation})
      : super(key: key);

  final Product product;
  final Function()? onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
      animation: animationController,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: PsDimens.space52,
          margin: const EdgeInsets.only(bottom: PsDimens.space4),
          child: Ink(
            color: PsColors.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(PsDimens.space16),
              child: Text(
                product.isSoldOut == '0' ? 'Not Sold Yet' : 'Sold Out',
                textAlign: TextAlign.start,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      builder: (BuildContext contenxt, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
