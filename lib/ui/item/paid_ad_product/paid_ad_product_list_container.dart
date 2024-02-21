

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/ui/item/paid_ad_product/paid_ad_product_list_view.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

class PaidAdProductListContainerView extends StatefulWidget {
  @override
  _PaidAdProductListContainerViewState createState() =>
      _PaidAdProductListContainerViewState();
}

class _PaidAdProductListContainerViewState
    extends State<PaidAdProductListContainerView>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController!.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    print(
        '............................Build UI Again ............................');
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
           systemOverlayStyle:  SystemUiOverlayStyle(
           statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
         ),  
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: Utils.isLightMode(context)? PsColors.primary500 : PsColors.primaryDarkWhite),
          title: Text(
            Utils.getString(context, 'home__drawer_menu_feature_item'),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Utils.isLightMode(context)? PsColors.primary500 : PsColors.primaryDarkWhite),
          ),
          elevation: 0,
        ),
        body: PaidAdProductListView(
          animationController: animationController,
        ),
      ),
    );
  }
}
