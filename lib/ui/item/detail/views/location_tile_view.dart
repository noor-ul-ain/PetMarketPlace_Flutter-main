

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/ui/common/ps_expansion_tile.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/map_pin_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:provider/provider.dart';

class LocationTileView extends StatefulWidget {
  const LocationTileView({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Product? item;

  @override
  _LocationTileViewState createState() => _LocationTileViewState();
}

class _LocationTileViewState extends State<LocationTileView> {
  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder = Provider.of<PsValueHolder>(context);
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'location_tile__title'),
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: PsColors.textColor2
        ));

    final Widget _expansionTileLeadingIconWidget = Icon(
      Typicons.location, //SimpleLineIcons.location_pin,
      color: PsColors.textColor2,
    );

    final Widget _expanionTitleWithLeadingIconWidget = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _expansionTileLeadingIconWidget,
        const SizedBox(
          width: PsDimens.space12,
        ),
        _expansionTileTitleWidget
      ],
    );

    // if (productDetail != null && productDetail.description != null) {
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
          bottom: PsDimens.space12),
      decoration: BoxDecoration(
        color: PsColors.cardBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(PsDimens.space8)),
      ),
      child:
       PsExpansionTile(
        initiallyExpanded: true,
      //  leading: _expansionTileLeadingWidget,
        title: _expanionTitleWithLeadingIconWidget,
        children: <Widget>[
          Column(
             crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // const Divider(
              //   height: PsDimens.space1,
              // ),
            //  Row(
            //    children: <Widget>[
            //     Padding(
            //             padding: const EdgeInsets.all(PsDimens.space12),
            //             child: Icon(
            //                 Typicons.location, //SimpleLineIcons.location_pin,
            //                 color: PsColors.secondary400,
            //               )
            //           ),
            //      Padding(
            //             padding: const EdgeInsets.symmetric(vertical : PsDimens.space12),
            //             child: Text(
            //                 Utils.getString(context, 'location_tile__title'),
            //                style: Theme.of(context).textTheme.subtitle1),
            //           ),
            //    ],
            //  ),
              if (widget.item!.address != null && widget.item!.address != '') 
                Padding(
                  padding: const EdgeInsets.only(left:PsDimens.space18),
                        child: Text(
                            widget.item!.address!,
                           style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                             color: PsColors.textColor2
                           )),)
              else 
                Center(
                  child: Text(
                        '__________________________________',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: PsColors.primary100
                        )),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[       
                  InkWell(
                      child: Ink(
                        child: Padding(
                          padding: const EdgeInsets.all(PsDimens.space16),
                          child: Text(
                            Utils.getString(
                                    context, 'location_tile__view_on_map_button')
                                .toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: PsColors.textColor1,fontSize: 12),
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (psValueHolder.isUseGoogleMap!) {
                          await Navigator.pushNamed(
                              context, RoutePaths.googleMapPin,
                              arguments: MapPinIntentHolder(
                                  flag: PsConst.VIEW_MAP,
                                  mapLat: widget.item!.lat,
                                  mapLng: widget.item!.lng));
                        } else {
                          await Navigator.pushNamed(context, RoutePaths.mapPin,
                              arguments: MapPinIntentHolder(
                                  flag: PsConst.VIEW_MAP,
                                  mapLat: widget.item!.lat,
                                  mapLng: widget.item!.lng));
                        }
                      }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
    // } else {
    //   return const Card();
    // }
  }
}
