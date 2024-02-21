

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_expansion_tile.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/deal_option.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/typicons_icons.dart';

class GettingThisTileView extends StatelessWidget {
  const GettingThisTileView({
    Key? key,
    required this.detailOption,
    required this.address,
  }) : super(key: key);

  final DealOption? detailOption;
  final String? address;
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'getting_this_tile__title'),
        style: Theme.of(context).textTheme.titleMedium);

    final Widget _expansionTileIconWidget = Icon(
      Elusive.lightbulb, //MaterialCommunityIcons.lightbulb_on_outline,
      color: PsColors.primary500,
    );
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
          bottom: PsDimens.space12),
      decoration: BoxDecoration(
        color: PsColors.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(PsDimens.space8)),
      ),
      child: PsExpansionTile(
        initiallyExpanded: true,
        leading: _expansionTileIconWidget,
        title: _expansionTileTitleWidget,
        children: <Widget>[
          Column(
            children: <Widget>[
              const Divider(
                height: PsDimens.space1,
              ),
              Padding(
                  padding: const EdgeInsets.all(PsDimens.space16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Typicons.location, //SimpleLineIcons.location_pin,
                        size: PsDimens.space20,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(
                        width: PsDimens.space40,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              Utils.getString(context, detailOption!.name),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(
                              height: PsDimens.space8,
                            ),
                            Text(
                              address != '' ? address! : '',
                              style: Theme.of(context).textTheme.bodyLarge,
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
