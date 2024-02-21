import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/product/search_product_provider.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/item_type.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:provider/provider.dart';

class ProductFilterWidget extends StatefulWidget {
  const ProductFilterWidget(
      {this.searchProductProvider, this.changeAppBarTitle});
  final SearchProductProvider? searchProductProvider;
  final Function? changeAppBarTitle;

  @override
  State<ProductFilterWidget> createState() => _ProductFilterWidgetState();
}

class _ProductFilterWidgetState extends State<ProductFilterWidget> {
  bool isClickBaseLineList = false;
  bool isClickBaseLineTune = false;
  late PsValueHolder valueHolder;
  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context);
    return Container(
      color: PsColors.baseColor,
      child: Ink(
        child: Padding(
          padding: const EdgeInsets.only(
            left: PsDimens.space24,
            top: PsDimens.space12,
            bottom: PsDimens.space12,
            right: PsDimens.space24,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // InkWell(
              //   onTap: () async {
              //     FocusScope.of(context).requestFocus(FocusNode());
              //     final dynamic itemTypeResult =
              //         await Navigator.pushNamed(context, RoutePaths.itemType);
              //
              //     if (itemTypeResult != null && itemTypeResult is ItemType) {
              //       widget.searchProductProvider!.productParameterHolder
              //           .itemTypeId = itemTypeResult.id;
              //       final String? loginUserId =
              //           Utils.checkUserLoginId(valueHolder);
              //       widget.searchProductProvider!.resetLatestProductList(
              //           loginUserId,
              //           widget.searchProductProvider!.productParameterHolder);
              //
              //       widget.searchProductProvider?.itemTypeId =
              //           itemTypeResult.id;
              //       widget.searchProductProvider?.selectedItemTypeName =
              //           itemTypeResult.name;
              //     } else if (itemTypeResult) {
              //       widget.searchProductProvider!.productParameterHolder
              //           .itemTypeId = '';
              //       final String? loginUserId =
              //           Utils.checkUserLoginId(valueHolder);
              //       widget.searchProductProvider!.resetLatestProductList(
              //           loginUserId,
              //           widget.searchProductProvider!.productParameterHolder);
              //       widget.searchProductProvider?.selectedItemTypeName =
              //           Utils.getString(context, 'product_list__category_all');
              //     }
              //   },
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: <Widget>[
              //       Text(
              //           widget.searchProductProvider!.selectedItemTypeName == ''
              //               ? Utils.getString(context, 'home_search__not_set')
              //               : widget
              //                   .searchProductProvider!.selectedItemTypeName!,
              //           style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              //               fontSize: 16,
              //               color: widget.searchProductProvider!
              //                           .selectedItemTypeName ==
              //                       ''
              //                   ? Utils.isLightMode(context)
              //                       ? PsColors.secondary400
              //                       : PsColors.primaryDarkWhite
              //                   : PsColors.textColor1)),
              //       const SizedBox(
              //         width: PsDimens.space10,
              //       ),
              //       Icon(
              //         FontAwesome.down_open,
              //         color: PsColors.textColor1,
              //         size: PsDimens.space12,
              //       ),
              //     ],
              //   ),
              // ),
              Container(),
              Row(
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      final Map<String, String?> dataHolder =
                          <String, String?>{};
                      dataHolder[PsConst.CATEGORY_ID] = widget
                          .searchProductProvider!.productParameterHolder.catId;
                      dataHolder[PsConst.SUB_CATEGORY_ID] = widget
                          .searchProductProvider!
                          .productParameterHolder
                          .subCatId;
                      final dynamic result = await Navigator.pushNamed(
                          context, RoutePaths.filterExpantion,
                          arguments: dataHolder);

                      if (result != null && result is Map<String, String?>) {
                        widget.searchProductProvider!.productParameterHolder
                            .catId = result[PsConst.CATEGORY_ID];

                        widget.searchProductProvider!.productParameterHolder
                            .subCatId = result[PsConst.SUB_CATEGORY_ID];
                        final String? loginUserId =
                            Utils.checkUserLoginId(valueHolder);
                        widget.searchProductProvider!.resetLatestProductList(
                            loginUserId,
                            widget
                                .searchProductProvider!.productParameterHolder);

                        if (result[PsConst.CATEGORY_ID] == '' &&
                            result[PsConst.SUB_CATEGORY_ID] == '') {
                          isClickBaseLineList = false;
                        } else {
                          widget.changeAppBarTitle!(
                              result[PsConst.CATEGORY_NAME]);
                          isClickBaseLineList = true;
                        }
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesome.tags,
                          color: PsColors.iconColor,
                          size: PsDimens.space12,
                        ),
                        const SizedBox(
                          width: PsDimens.space4,
                        ),
                        Text(Utils.getString(context, 'search__category'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontSize: 16,
                                    color: widget.searchProductProvider!
                                                .productParameterHolder.catId ==
                                            ''
                                        ? Utils.isLightMode(context)
                                            ? PsColors.secondary400
                                            : PsColors.primaryDarkWhite
                                        : PsColors.textColor1)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: PsDimens.space10,
                  ),
                  InkWell(
                    onTap: () async {
                      final dynamic result = await Navigator.pushNamed(
                          context, RoutePaths.itemSearch,
                          arguments: widget
                              .searchProductProvider!.productParameterHolder);
                      if (result != null && result is ProductParameterHolder) {
                        widget.searchProductProvider!.productParameterHolder =
                            result;
                        final String? loginUserId =
                            Utils.checkUserLoginId(valueHolder);
                        widget.searchProductProvider!.resetLatestProductList(
                            loginUserId,
                            widget
                                .searchProductProvider!.productParameterHolder);

                        if (widget.searchProductProvider!.productParameterHolder
                            .isFiltered()) {
                          isClickBaseLineTune = true;
                        } else {
                          isClickBaseLineTune = false;
                        }
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          FontAwesome.filter,
                          color: PsColors.iconColor,
                          size: PsDimens.space12,
                        ),
                        const SizedBox(
                          width: PsDimens.space4,
                        ),
                        Text(
                          Utils.getString(context, 'search__filter'),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  fontSize: 16,
                                  color: widget
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .searchTerm ==
                                              '' &&
                                          //      widget.searchProductProvider!.productParameterHolder.catId == '' &&
                                          //      widget.searchProductProvider!.productParameterHolder.subCatId == '' &&
                                          widget
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .maxPrice ==
                                              '' &&
                                          widget
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .minPrice ==
                                              '' &&
                                          widget
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .dealOptionId ==
                                              '' &&
                                          widget
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .isSoldOut ==
                                              '' &&
                                          widget
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .itemPriceTypeId ==
                                              '' &&
                                          widget
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .conditionOfItemId ==
                                              '' &&
                                          widget 
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .itemLocationId == 
                                              '' &&
                                          widget 
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .itemLocationTownshipId == 
                                              ''          
                                      ? Utils.isLightMode(context)
                                          ? PsColors.secondary400
                                          : PsColors.primaryDarkWhite
                                      : PsColors.textColor1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: PsDimens.space10,
                  ),
                  InkWell(
                    onTap: () async {
                      if (valueHolder.isSubLocation == PsConst.ONE) {
                        if (widget.searchProductProvider!.productParameterHolder
                                    .lat ==
                                '' &&
                            widget.searchProductProvider!.productParameterHolder
                                    .lng ==
                                '') {
                         
                          widget.searchProductProvider!.productParameterHolder
                                  .lat =
                              widget.searchProductProvider!.psValueHolder!
                                  .locationTownshipLat;
                          widget.searchProductProvider!.productParameterHolder
                                  .lng =
                              widget.searchProductProvider!.psValueHolder!
                                  .locationTownshipLng;
                            
                            if(widget.searchProductProvider!.psValueHolder!
                                  .locationTownshipLat == '' && widget.searchProductProvider!.psValueHolder!
                                  .locationTownshipLng == ''){

                             widget.searchProductProvider!.productParameterHolder
                                       .lat =
                                   widget.searchProductProvider!.psValueHolder!
                                       .locationLat;
                               widget.searchProductProvider!.productParameterHolder
                                       .lng =
                                   widget.searchProductProvider!.psValueHolder!
                                  .locationLng;
                                  }
                           
                        }
                      } else {
                        if (widget.searchProductProvider!.productParameterHolder
                                    .lat ==
                                '' &&
                            widget.searchProductProvider!.productParameterHolder
                                    .lng ==
                                '') {
                          widget.searchProductProvider!.productParameterHolder
                                  .lat =
                              widget.searchProductProvider!.psValueHolder!
                                  .locationLat;
                          widget.searchProductProvider!.productParameterHolder
                                  .lng =
                              widget.searchProductProvider!.psValueHolder!
                                  .locationLng;
                        }
                      }
                      if (valueHolder.isUseGoogleMap!) {
                        final dynamic result = await Navigator.pushNamed(
                            context, RoutePaths.googleMapFilter,
                            arguments: widget
                                .searchProductProvider!.productParameterHolder);
                        if (result != null &&
                            result is ProductParameterHolder) {
                          widget.searchProductProvider!.productParameterHolder =
                              result;
                          if (widget.searchProductProvider!
                                      .productParameterHolder.mile !=
                                  null &&
                              widget.searchProductProvider!
                                      .productParameterHolder.mile !=
                                  '' &&
                              double.parse(widget.searchProductProvider!
                                      .productParameterHolder.mile!) <
                                  1) {
                            widget.searchProductProvider!.productParameterHolder
                                .mile = '1';
                          }
                          final String? loginUserId =
                              Utils.checkUserLoginId(valueHolder);
                          //for 0.5 km, it is less than 1 miles and error
                          widget.searchProductProvider!.resetLatestProductList(
                              loginUserId,
                              widget.searchProductProvider!
                                  .productParameterHolder);
                        }
                      } else {
                        final dynamic result = await Navigator.pushNamed(
                            context, RoutePaths.mapFilter,
                            arguments: widget
                                .searchProductProvider!.productParameterHolder);
                        if (result != null &&
                            result is ProductParameterHolder) {
                          widget.searchProductProvider!.productParameterHolder =
                              result;
                          if (widget.searchProductProvider!
                                      .productParameterHolder.mile !=
                                  null &&
                              widget.searchProductProvider!
                                      .productParameterHolder.mile !=
                                  '' &&
                              double.parse(widget.searchProductProvider!
                                      .productParameterHolder.mile!) <
                                  1) {
                            widget.searchProductProvider!.productParameterHolder
                                .mile = '1';
                          }
                          final String? loginUserId =
                              Utils.checkUserLoginId(valueHolder);
                          //for 0.5 km, it is less than 1 miles and error
                          widget.searchProductProvider!.resetLatestProductList(
                              loginUserId,
                              widget.searchProductProvider!
                                  .productParameterHolder);
                        }
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.gps_fixed,
                          color: PsColors.iconColor,
                          size: PsDimens.space12,
                        ),
                        const SizedBox(
                          width: PsDimens.space4,
                        ),
                        Text(
                          Utils.getString(context, 'search__map'),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  fontSize: 16,
                                  color: widget.searchProductProvider!
                                                  .productParameterHolder.lat ==
                                              '' &&
                                          widget.searchProductProvider!
                                                  .productParameterHolder.lng ==
                                              '' &&
                                          widget
                                                  .searchProductProvider!
                                                  .productParameterHolder
                                                  .maxPrice ==
                                              ''
                                      ? Utils.isLightMode(context)
                                          ? PsColors.secondary400
                                          : PsColors.primaryDarkWhite
                                      : PsColors.textColor1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}