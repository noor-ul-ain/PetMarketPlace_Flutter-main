import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

class MyHeaderWidget extends StatefulWidget {
  const MyHeaderWidget({
    Key? key,
    required this.headerName,
    this.headerDescription,
    required this.viewAllClicked,
  }) : super(key: key);

  final String headerName;
  final String? headerDescription;
  final Function viewAllClicked;

  @override
  _MyHeaderWidgetState createState() => _MyHeaderWidgetState();
}

class _MyHeaderWidgetState extends State<MyHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.viewAllClicked as void Function()?,
      child: Padding(
        padding: const EdgeInsets.only(
            top: PsDimens.space20,
            left: PsDimens.space16,
            right: PsDimens.space16,
            bottom: PsDimens.space10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  //   fit: FlexFit.loose,
                  child: Text(widget.headerName,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: PsColors.textColor2)),
                ),
                Text(
                  Utils.getString(context, 'dashboard__view_all'),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: PsColors.textColor3),
                ),
              ],
            ),
            if (widget.headerDescription == '')
              Container()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: PsDimens.space10),
                      child: Text(
                        widget.headerDescription!,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Utils.isLightMode(context)
                                ? PsColors.secondary300
                                : PsColors.primaryDarkGrey),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
