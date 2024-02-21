import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/package.dart';

class PackageItem extends StatelessWidget {
  const PackageItem({
    Key? key,
    required this.package,
    required this.onTap,
    required this.priceWithCurrency,
    required this.isNewUi,
  }) : super(key: key);

  final Package package;
  final bool isNewUi;
  final Function? onTap;
  final String priceWithCurrency;

  @override
  Widget build(BuildContext context) {
    if(isNewUi){
      const Color redColor = Color(0xffaa232a);
      return InkWell(
        onTap: onTap as void Function()?,
        child: Container(
          width: MediaQuery.of(context).size.width/4,
          // height: 200,
          margin: const EdgeInsets.only(left: PsDimens.space10, bottom: 0),
          padding: const EdgeInsets.only(top: PsDimens.space8, left: PsDimens.space8, right: PsDimens.space8),
          decoration: BoxDecoration(
            //  color: Utils.isLightMode(context) ? Colors.white60 : Colors.black54,
            color: redColor,
            borderRadius: BorderRadius.circular(PsDimens.space8),
            // border: Border.all(color: Utils.isLightMode(context) ? Colors.grey[350]! : Colors.black87),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FittedBox( fit: BoxFit.scaleDown,
                  child: Text(
                    package.title!,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
                  ),
                ),
                Text(
                  'Buy and create ${package.postCount} new posts.',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                      // color: PsColors
                      //     .textColor2,
                      fontSize: 12),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FittedBox( fit: BoxFit.scaleDown,
                        child: Text(
                          priceWithCurrency.replaceAll('.00', ''),
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                // color: PsColors
                            color: Colors.white,
                                //     .textColor1,
                                // fontSize: 18,
                              ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward,color: Colors.white,size: 20),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      );
    }
    else{
      return Container(
        margin: const EdgeInsets.only(left: PsDimens.space10, bottom: PsDimens.space8),
        padding: const EdgeInsets.only(top: PsDimens.space8, left: PsDimens.space8, right: PsDimens.space8),
        decoration: BoxDecoration(
          //  color: Utils.isLightMode(context) ? Colors.white60 : Colors.black54,
          borderRadius: BorderRadius.circular(PsDimens.space8),
          border: Border.all(color: Utils.isLightMode(context) ? Colors.grey[350]! : Colors.black87),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              package.title!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Buy and create ${package.postCount} new posts.',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                // color: PsColors
                //     .textColor2,
                  fontSize: 12),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                priceWithCurrency,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  // color: PsColors
                  //     .textColor1,
                  fontSize: 18,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: MaterialButton(
                color: PsColors.activeColor,
                height: 28,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(PsDimens.space8)),
                ),
                child: Text(
                  Utils.getString(context, 'item_promote__purchase_buy'),
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(color: PsColors.baseColor),
                ),
                onPressed: onTap as void Function()?,
              ),
            ),
          ],
        ),
      );
    }
  }
}
