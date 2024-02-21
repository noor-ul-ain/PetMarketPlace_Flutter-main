

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/ps_app_version.dart';
import 'package:provider/provider.dart';

class ForceUpdateView extends StatelessWidget {
  ForceUpdateView({required this.psAppVersion});
  final PSAppVersion psAppVersion;
  final Widget _imageWidget = Container(
    width: 90,
    height: 90,
    child: Image.asset(
      'assets/images/flutter_buy_and_sell_logo.png',
    ),
  );
  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder = Provider.of<PsValueHolder>(context);
    return Container(
        height: 100,
        color: PsColors.primary50,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: PsDimens.space80,
                    ),
                    _imageWidget,
                    const SizedBox(
                      height: PsDimens.space16,
                    ),
                    Text(Utils.getString(context, 'app_name'),
                        style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: PsDimens.space16, right: PsDimens.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const SizedBox(
                      height: PsDimens.space32,
                    ),
                    Text(psAppVersion.versionTitle!,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(
                      height: PsDimens.space8,
                    ),
                    Container(
                        height: PsDimens.space100,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(psAppVersion.versionMessage!,
                              maxLines: 9,
                              style: Theme.of(context).textTheme.bodyLarge),
                        )),
                    const SizedBox(
                      height: PsDimens.space8,
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: PsDimens.space32, right: PsDimens.space32),
                      child: MaterialButton(
                        color: PsColors.primary500,
                        height: 45,
                        minWidth: double.infinity,
                        shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        ),
                        child: Text(
                          Utils.getString(context, 'force_update__update'),
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: PsColors.white),
                        ),
                        onPressed: () async {
                          // Navigator.pushReplacementNamed(
                          //   context,
                          //   RoutePaths.home,
                          // );

                          if (Platform.isIOS) {
                            Utils.launchAppStoreURL(
                                iOSAppId: psValueHolder.iosAppStoreId);
                          } else if (Platform.isAndroid) {
                            Utils.launchURL();
                          }
                        },
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }
}
