import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/item_location/item_location_provider.dart';
import 'package:flutterbuyandsell/repository/item_location_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar_no_app_bar_title.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/ps_textfield_widget_with_icon.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/location_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/item_location.dart';
import 'package:flutterbuyandsell/viewobject/item_location_township.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:provider/provider.dart';

class ItemLocationView extends StatefulWidget {
  const ItemLocationView({Key? key, required this.animationController})
      : super(key: key);

  final AnimationController? animationController;
  @override
  _ItemLocationViewState createState() => _ItemLocationViewState();
}

class _ItemLocationViewState extends State<ItemLocationView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late ItemLocationProvider _itemLocationProvider;
  PsValueHolder? valueHolder;

  // Animation<double> animation;
  int i = 0;
  @override
  void dispose() {
    // animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _itemLocationProvider.nextItemLocationList(
            _itemLocationProvider.latestLocationParameterHolder.toMap(),
            Utils.checkUserLoginId(_itemLocationProvider.psValueHolder!));
      }
    });

    super.initState();
  }

  ItemLocationRepository? repo1;
  dynamic data;

  @override
  Widget build(BuildContext context) {
    // data = EasyLocalizationProvider.of(context).data;
    repo1 = Provider.of<ItemLocationRepository>(context);
    valueHolder = Provider.of<PsValueHolder?>(context);
    print(
        '............................Build Item Location UI Again ............................');

    return PsWidgetWithAppBarNoAppBarTitle<ItemLocationProvider>(initProvider:
        () {
      return ItemLocationProvider(repo: repo1, psValueHolder: valueHolder);
    }, onProviderReady: (ItemLocationProvider provider) {
      provider.latestLocationParameterHolder.keyword =
          searchCityNameController.text;
      provider.latestLocationParameterHolder.keyword =
          searchTownshipNameController.text;
      provider.loadItemLocationList(
          provider.latestLocationParameterHolder.toMap(),
          Utils.checkUserLoginId(provider.psValueHolder!));
      _itemLocationProvider = provider;
    }, builder:
        (BuildContext context, ItemLocationProvider provider, Widget? child) {
      return ItemLocationListViewWidget(
        scrollController: _scrollController,
        animationController: widget.animationController,
      );
    });
  }
}

class ItemLocationListViewWidget extends StatefulWidget {
  const ItemLocationListViewWidget(
      {Key? key,
      required this.scrollController,
      required this.animationController})
      : super(key: key);

  final ScrollController scrollController;
  final AnimationController? animationController;

  @override
  _ItemLocationListViewWidgetState createState() =>
      _ItemLocationListViewWidgetState();
}

LocationParameterHolder locationParameterHolder =
    LocationParameterHolder().getDefaultParameterHolder();
final TextEditingController searchCityNameController = TextEditingController();
final TextEditingController searchTownshipNameController =
    TextEditingController();

class _ItemLocationListViewWidgetState
    extends State<ItemLocationListViewWidget> {
  // Widget? _widget;
//  late PsValueHolder valueHolder;
  String isSubLocation = '0';

  final SvgPicture locationSVG = SvgPicture.asset(
              'assets/images/loaction_illustration.svg',
              width: double.infinity,
              height: 400
              );
  bool isFirstTime = true;            

  @override
  Widget build(BuildContext context) {
    final PsValueHolder valueHolder = Provider.of<PsValueHolder>(context);
    final ItemLocationProvider _provider = Provider.of(context, listen: false);
    if (valueHolder.locationId != null && valueHolder.locationId != '') {
      searchCityNameController.text = valueHolder.locactionName ?? '';
      _provider.itemLocationId = valueHolder.locationId;
      _provider.itemLocationName = valueHolder.locactionName;
      _provider.itemLocationLat = valueHolder.locationLat;
      _provider.itemLocationLng = valueHolder.locationLng;

      if (isFirstTime && valueHolder.locationTownshipId != '') {
        searchTownshipNameController.text = valueHolder.locationTownshipName;  
        _provider.itemLocationTownshipId = valueHolder.locationTownshipId;
        _provider.itemLocationTownshipName = valueHolder.locationTownshipName;
        _provider.itemLocationLat = valueHolder.locationTownshipLat;
        _provider.itemLocationLng = valueHolder.locationTownshipLng;
        isFirstTime = false;
      }
    }
      
    

    return SingleChildScrollView(
      child: Container(
        // color: PsColors.primaryDarkWhite,
        child: Column(
          children: <Widget>[
            Container(
              color: PsColors.primary50,
              child: locationSVG
              ),
            const SizedBox(
              height: PsDimens.space12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: PsDimens.space28, top: PsDimens.space16,right: PsDimens.space28),
                  child: Text(Utils.getString(context, 'Select Your Location'),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Utils.isLightMode(context)
                              ? PsColors.secondary400
                              : PsColors.primaryDarkWhite)),
                ),
                const SizedBox(
                  height: PsDimens.space8,
                ),
                Container(
                    margin: const EdgeInsets.only(
                        left: PsDimens.space16,
                        right: PsDimens.space16,
                        top: PsDimens.space16),
                    child: PsTextFieldWidgetWithIcon2(
                      hintText: Utils.getString(context, 'Enter Ciy'),
                      textEditingController: searchCityNameController,
                      psValueHolder: _provider.psValueHolder,
                      onTap: () async {

                      //  searchCityNameController.text = '';
                        final dynamic itemLocationResult =
                            await Navigator.pushNamed(
                                context, RoutePaths.itemLocationFirst);

                        if (itemLocationResult != null &&
                            itemLocationResult is ItemLocation) {
                          _provider.itemLocationId = itemLocationResult.id;
                          

                          setState(() {
                            searchTownshipNameController.text = '';
                            searchCityNameController.text =
                                itemLocationResult.name!;
                            _provider.itemLocationName =
                                itemLocationResult.name;
                            _provider.itemLocationLat = itemLocationResult.lat;
                            _provider.itemLocationLng = itemLocationResult.lng;
                          });

                          _provider.itemLocationTownshipId = '';
                          _provider.itemLocationTownshipName = '';
                          _provider.itemLocationTownshipLat = '';
                          _provider.itemLocationTownshipLng = '';

                        }else {
                            _provider.itemLocationId = '';
                            _provider.itemLocationName =
                                          Utils.getString(context,
                                              'product_list__category_all');

                            _provider.itemLocationTownshipId = '';
                          _provider.itemLocationTownshipName = '';
                          _provider.itemLocationTownshipLat = '';
                          _provider.itemLocationTownshipLng = '';                  

                          }
                        
                        
                      },
                    )),
                if (valueHolder.isSubLocation == PsConst.ONE)    
                  Container(
                    margin: const EdgeInsets.only(
                        left: PsDimens.space16,
                        right: PsDimens.space16,
                        top: PsDimens.space16),
                    child: PsTextFieldWidgetWithIcon2(
                      hintText: Utils.getString(context, 'Enter Township'),
                      textEditingController: searchTownshipNameController,
                      psValueHolder: _provider.psValueHolder,
                      onTap: () async {
                        if (_provider.itemLocationId != '') {
                           searchTownshipNameController.text =  '';
                          final dynamic itemLocationResult =
                              await Navigator.pushNamed(
                                  context, RoutePaths.itemLocationTownshipFirst,
                                  arguments: _provider.itemLocationId);

                          if (itemLocationResult != null &&
                              itemLocationResult is ItemLocationTownship) {
                            _provider.itemLocationTownshipId =
                                itemLocationResult.id;
                           isSubLocation = PsConst.ONE;
                            setState(() {
                              searchTownshipNameController.text =
                                  itemLocationResult.townshipName!;
                              _provider.itemLocationTownshipLat =
                                  itemLocationResult.lat;
                              _provider.itemLocationTownshipLng =
                                  itemLocationResult.lng;
                            });
                          }else {
                            _provider.itemLocationTownshipId = '';
                            _provider.selectedTownshipName =
                                          Utils.getString(context,
                                              'product_list__category_all');

                          }
                        } else {
                          showDialog<dynamic>(
                              context: context,
                              builder: (BuildContext context) {
                                return ErrorDialog(
                                  message: Utils.getString(context,
                                      'home_search__choose_city_first'),
                                );
                              });
                          const ErrorDialog(message: 'Choose City first');
                        }
                      },
                    )),
                const SizedBox(
                  height: PsDimens.space100,
                ),
                InkWell(
                  onTap: () async {
                    if (_provider.itemLocationId == '') {
                       await _provider.replaceItemLocationData(
                                      '',
                                      Utils.getString(context,
                                          'product_list__category_all'),
                                      PsConst.INVALID_LAT_LNG,
                                      PsConst.INVALID_LAT_LNG);

                                  await _provider
                                      .replaceItemLocationTownshipData(
                                    '',
                                    '',
                                    Utils.getString(
                                        context, 'product_list__category_all'),
                                    PsConst.INVALID_LAT_LNG,
                                    PsConst.INVALID_LAT_LNG,
                                  );
                                    Navigator.pushReplacementNamed(
                                      context, RoutePaths.home);
                      // showDialog<dynamic>(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return const ErrorDialog(
                      //         message: 'Please select City',
                      //       );
                      //     });
                    } else {
                      await _provider.replaceItemLocationData(
                        _provider.itemLocationId!,
                        _provider.itemLocationName!,
                        _provider.itemLocationLat!,
                        _provider.itemLocationLng!,
                      );
                      await _provider.replaceItemLocationTownshipData(
                          _provider.itemLocationTownshipId!,
                          _provider.itemLocationId!,
                          _provider.itemLocationTownshipName!,
                          _provider.itemLocationTownshipLat!,
                          _provider.itemLocationTownshipLng!);
                      Navigator.pushReplacementNamed(context, RoutePaths.home);
                    //  await _provider.replaceIsSubLocation(isSubLocation);
                   }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: PsDimens.space10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(Utils.getString(context, 'location_first_explore'),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Utils.isLightMode(context)
                                        ? PsColors.primary500
                                        : PsColors.primaryDarkWhite)),
                        const SizedBox(
                          width: PsDimens.space8,
                        ),
                        Icon(
                          FontAwesome.right,
                          color: Utils.isLightMode(context)
                              ? PsColors.primary500
                              : PsColors.primaryDarkWhite,
                        ),
                      ],
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

class ItemLocationHeaderTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: PsDimens.space32),
      child: Container(
          color: PsColors.primary50,
          child: SvgPicture.asset(
              'assets/images/loaction_illustration.svg',
              width: double.infinity,
              height: 400)),
    );
  }
}
