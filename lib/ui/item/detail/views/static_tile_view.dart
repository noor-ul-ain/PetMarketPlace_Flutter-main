import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/provider/product/product_provider.dart';
import 'package:flutterbuyandsell/ui/common/ps_expansion_tile.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/mfg_labs_icons.dart';

class StatisticTileView extends StatefulWidget {
  const StatisticTileView(this.itemDetail);
  final ItemDetailProvider itemDetail;

  @override
  _StatisticTileViewState createState() => _StatisticTileViewState();
}

class _StatisticTileViewState extends State<StatisticTileView> {
  @override
  Widget build(BuildContext context) {
    return _StatisticBuildTileswidget(itemDetail: widget.itemDetail);
  }
}

class _StatisticBuildTileswidget extends StatelessWidget {
  const _StatisticBuildTileswidget({this.itemDetail});
  final ItemDetailProvider? itemDetail;

  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'statistic_tile__title'),
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: PsColors.textColor2
        ));

    final Widget _expansionTileLeadingIconWidget = Icon(
      MfgLabs.chart_bar, //Foundation.graph_bar,
      color: PsColors.textColor2,
    );
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space16,
    );

    final Widget _verticalLineWidget = Container(
      color: Theme.of(context).dividerColor,
      width: PsDimens.space1,
      height: PsDimens.space36,
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

    if (itemDetail != null && itemDetail!.itemDetail.data != null) {
      return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space12,
            right: PsDimens.space12,
            bottom: PsDimens.space12),
        decoration: BoxDecoration(
          color: PsColors.cardBackgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        child: 
        PsExpansionTile(
          initiallyExpanded: true,
        //  leading: _expansionTileIconWidget,
          title: _expanionTitleWithLeadingIconWidget,
          children: <Widget>[
            Column(
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.only(left: PsDimens.space16,top:PsDimens.space12,),
                //   child: Row(
                //     children: <Widget>[
                //       Icon(
                //           MfgLabs.chart_bar, //Foundation.graph_bar,
                //           color: PsColors.secondary400,
                //         ),
                //           const SizedBox( width: PsDimens.space12, ),
                //   Text(
                //       Utils.getString(context, 'statistic_tile__title'),
                //       style: Theme.of(context).textTheme.subtitle1),
                //         ],
                //   ),
                // ),
                //        Divider(
                //       height: PsDimens.space1,
                //       color: Theme.of(context).iconTheme.color,
                // ),
                const SizedBox(
                  height: PsDimens.space4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _IconAndTextWidget(
                        icon: FontAwesome5.eye , //SimpleLineIcons.eyeglass,
                        title:
                            '${itemDetail!.itemDetail.data!.touchCount} ',
                        title2:'${Utils.getString(context, 'statistic_tile__views')}' ,
                        textType: 0),
                    _verticalLineWidget,
                    _IconAndTextWidget(
                        icon: Icons.favorite,
                        title:
                            '${itemDetail!.itemDetail.data!.favouriteCount} ',
                        title2:'${Utils.getString(context, 'item_detail__like_count')}' ,
                        textType: 3),
                  ],
                ),
                _spacingWidget
              ],
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class _IconAndTextWidget extends StatelessWidget {
  const _IconAndTextWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.title2,
    required this.textType,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final String title2;
  final int textType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
                InkWell(
          onTap: () {
            // textType == 1
            //     ? Navigator.pushNamed(
            //         context,
            //         Directory1RoutePaths.ratingList,
            //       )
            //     : textType == 2
            //         ? Navigator.pushNamed(
            //             context,
            //             Directory1RoutePaths.commentList,
            //           )
            //         : const Text('Hello');
          },
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: PsColors.textColor2),
                // color: textType == 0
                //     ? Theme.of(context).iconTheme.color
                //     : textType == 3
                //         ? Theme.of(context).iconTheme.color
                //         : PsColors.primary500),
          ),
        ),
        const SizedBox(
          height: PsDimens.space2,
        ),
        Row(
          children:<Widget> [

            Icon(
              icon,
              size: PsDimens.space12,
              color: PsColors.textColor3,
            ),
          const SizedBox(
          width: PsDimens.space6),
           Text(
            title2,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: PsColors.textColor3,
              fontSize: 14.0,
                // color: textType == 0
                //     ? Theme.of(context).iconTheme.color
                //     : textType == 3
                //         ? Theme.of(context).iconTheme.color
                //         : PsColors.primary500
                        ),
          ),
          ],
        ),
      ],
    );
  }
}
