

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

class PsWidgetWithAppBarWithNoProvider extends StatefulWidget {
  const PsWidgetWithAppBarWithNoProvider(
      {Key? key,
      this.builder,
      required this.child,
      required this.appBarTitle,
      this.actions = const <Widget>[]})
      : super(key: key);

  final Widget Function(BuildContext context, Widget child)? builder;

  final Widget child;

  final String appBarTitle;
  final List<Widget> actions;

  @override
  _PsWidgetWithAppBarWithNoProviderState createState() =>
      _PsWidgetWithAppBarWithNoProviderState();
}

class _PsWidgetWithAppBarWithNoProviderState
    extends State<PsWidgetWithAppBarWithNoProvider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final dynamic data = EasyLocalizationProvider.of(context).data;
    // return EasyLocalizationProvider(
    //     data: data,
    //     child:
    return Scaffold(
      appBar: AppBar(
             systemOverlayStyle:  SystemUiOverlayStyle(
           statusBarIconBrightness: Utils.getBrightnessForAppBar(context),
         ),  
        iconTheme: IconThemeData(color: PsColors.backArrowColor),// Utils.isLightMode(context)?PsColors.primary500 : PsColors.primaryDarkWhite),
        title: Text(widget.appBarTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold)
                // .copyWith(color: Utils.isLightMode(context)?PsColors.primary500 : PsColors.primaryDarkWhite
                // )
                ),
        actions: widget.actions,
        flexibleSpace: Container(
          height: 200,
        ),
        elevation: 0,
      ),
      body: widget.child,
      // )
    );
  }
}
