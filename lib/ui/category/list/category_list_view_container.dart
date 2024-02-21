

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

import 'category_list_view.dart';

class CategoryListViewContainerView extends StatefulWidget {
  const CategoryListViewContainerView({this.appBarTitle});

  final String? appBarTitle;
  @override
  _CategoryListWithFilterContainerViewState createState() =>
      _CategoryListWithFilterContainerViewState();
}

class _CategoryListWithFilterContainerViewState
    extends State<CategoryListViewContainerView>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
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
      //  backgroundColor: PsColors.baseColor,
        appBar: AppBar(
                    systemOverlayStyle:  SystemUiOverlayStyle(
           statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
         ),  
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: Utils.isLightMode(context)? PsColors.primary500 : PsColors.primaryDarkWhite),
          title: Text(
            widget.appBarTitle!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Utils.isLightMode(context)? PsColors.primary500 : PsColors.primaryDarkWhite),
          ),
          elevation: 0,
        ),
        body: Container(
          color: PsColors.baseColor,
          child: CategoryListView()),
      ),
    );
  }
}
