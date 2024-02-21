

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

class PsTextFieldWidget extends StatelessWidget {
  const PsTextFieldWidget(
      {this.textEditingController,
      this.titleText = '',
      this.hintText,
      this.textAboutMe = false,
      this.height = PsDimens.space44,
      this.showTitle = true,
      this.keyboardType = TextInputType.text,
      this.isStar = false,
      this.isEnable = true});

  final TextEditingController? textEditingController;
  final String titleText;
  final String? hintText;
  final double height;
  final bool textAboutMe;
  final TextInputType keyboardType;
  final bool showTitle;
  final bool isStar;
  final bool isEnable;

  @override
  Widget build(BuildContext context) {
    final Widget _productTextWidget =
        Text(titleText, style: Theme.of(context).textTheme.bodyMedium);

    return Column(
      children: <Widget>[
        if (showTitle)
          Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space12,
                top: PsDimens.space12,
                right: PsDimens.space12),
            child: Row(
              children: <Widget>[
                if (isStar)
                  Row(
                    children: <Widget>[
                      Text(titleText,
                          style: Theme.of(context).textTheme.bodyMedium),
                      Text(' *',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: PsColors.activeColor))
                    ],
                  )
                else
                  _productTextWidget
              ],
            ),
          )
        else
          Container(
            height: 0,
          ),
        Container(
            width: double.infinity,
            height: height,
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
              color: PsColors.cardBackgroundColor,//PsColors.primary50,
              borderRadius: BorderRadius.circular(PsDimens.space10),
             // border: Border.all(color: PsColors.mainDividerColor),
            ),
            child: TextField(
                keyboardType: keyboardType,
                maxLines: null,
                textDirection: TextDirection.ltr,
                textAlign: Directionality.of(context) == TextDirection.ltr
                    ? TextAlign.left
                    : TextAlign.right,
                controller: textEditingController,
                style: Theme.of(context).textTheme.bodyLarge,
                enabled: isEnable,
                decoration: textAboutMe
                    ? InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          left: PsDimens.space12,
                          bottom: PsDimens.space8,
                          top: PsDimens.space10,
                        ),
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Utils.isLightMode(context)? PsColors.textPrimaryLightColor: PsColors.primaryDarkGrey),
                      )
                    : InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          left: PsDimens.space12,
                          bottom: PsDimens.space8,
                        ),
                        border: InputBorder.none,
                        hintText: hintText,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color:  Utils.isLightMode(context)? PsColors.textPrimaryLightColor: PsColors.primaryDarkGrey),
                      ))),
      ],
    );
  }
}
