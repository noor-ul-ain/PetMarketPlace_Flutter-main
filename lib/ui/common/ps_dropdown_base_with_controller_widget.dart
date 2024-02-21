

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

class PsDropdownBaseWithControllerWidget extends StatelessWidget {
  const PsDropdownBaseWithControllerWidget(
      {Key? key,
      required this.title,
      required this.onTap,
      this.textEditingController,
      this.isStar = false})
      : super(key: key);

  final String title;
  final TextEditingController? textEditingController;
  final Function onTap;
  final bool isStar;

  @override
  Widget build(BuildContext context) {
    final Widget _productTextWidget =
        Text(title, style: Theme.of(context).textTheme.bodyMedium);
    final Widget _productTextWithStarWidget = Row(
      children: <Widget>[
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        Text(' *',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: PsColors.activeColor))
      ],
    );

    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12,
              top: PsDimens.space4,
              right: PsDimens.space12),
          child: Row(
            children: <Widget>[
              if (isStar) _productTextWithStarWidget,
              if (!isStar) _productTextWidget,
            ],
          ),
        ),
        InkWell(
          onTap: onTap as void Function()?,
          child: Container(
           // color: PsColors.primary50,
            width: double.infinity,
            height: PsDimens.space44,
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
              color: PsColors.cardBackgroundColor,
              borderRadius: BorderRadius.circular(PsDimens.space10),
              //border: Border.all(color: PsColors.mainDividerColor),
            ),
            // child: Ink(
              child: Container(
              //  margin: const EdgeInsets.all(PsDimens.space12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: InkWell(
                        // child: Ink(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              textEditingController!.text == ''
                                  ? Utils.getString(context, 'home_search__not_set')
                                  : textEditingController!.text,
                              overflow: TextOverflow.ellipsis,
                              style: textEditingController!.text == ''
                                  ? Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Utils.isLightMode(context)? PsColors.textPrimaryLightColor: PsColors.primaryDarkGrey)
                                  : Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        //),
                      ),
                    ),
                    const Padding(
                      padding:  EdgeInsets.only(right: PsDimens.space40),
                      child:  Icon(
                        Icons.arrow_drop_down,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        //),
      ],
    );
  }
}
