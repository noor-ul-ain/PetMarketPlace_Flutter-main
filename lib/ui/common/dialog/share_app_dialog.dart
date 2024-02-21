

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareAppDialog extends StatefulWidget {
  const ShareAppDialog({this.message, this.onPressed});
  final String? message;
  final Function? onPressed;

  @override
  _ShareAppDialogState createState() => _ShareAppDialogState();
}

class _ShareAppDialogState extends State<ShareAppDialog> {
  @override
  Widget build(BuildContext context) {
    return _NewDialog(widget: widget);
  }
}

class _NewDialog extends StatelessWidget {
  const _NewDialog({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final ShareAppDialog widget;

  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder = Provider.of<PsValueHolder>(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                height: 50,
                width: double.infinity,
                padding: const EdgeInsets.all(PsDimens.space8),
                margin:  const EdgeInsets.all(PsDimens.space8),
                child: 
                    Text(
                      Utils.getString(context, 'share_app'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: PsColors.textColor2,fontSize: PsDimens.space18
                      ),
                    ),
                ),
            Container(
              width: 200,
              child: PSButtonWidget(
                   colorData: PsColors.activeColor,
                   hasShadow: true,
                   titleText: Utils.getString(
                       context, 'share_android_app'),
                   onPressed: () async {
                     final Size size = MediaQuery.of(context).size;
                       Share.share(
                           psValueHolder.googlePlayStoreUrl!,
                          
                          sharePositionOrigin:
                              Rect.fromLTWH(0, 0, size.width, size.height / 2),
                        );
                         Navigator.pop(context);
                    },
                    
                    ),
            ),
            const SizedBox(height: PsDimens.space20),
           Container(
              width: 200,
              child: PSButtonWidget(
                    colorData: PsColors.buttonColor,
                   hasShadow: true,
                   titleText: Utils.getString(
                       context, 'share_ios_app'),
                   onPressed: () async {
                      final Size size = MediaQuery.of(context).size;
                       Share.share(
                           psValueHolder.appleAppStoreUrl!,
                          
                          sharePositionOrigin:
                              Rect.fromLTWH(0, 0, size.width, size.height / 2),
                        );
                         Navigator.pop(context);},
                    ),
            ),
             const SizedBox(height: PsDimens.space20),
          ],
        ),
      ),
    );
  }
}
