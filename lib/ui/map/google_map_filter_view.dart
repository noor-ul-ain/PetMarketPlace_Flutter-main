

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget_with_round_corner.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleMapFilterView extends StatefulWidget {
  const GoogleMapFilterView({required this.productParameterHolder});

  final ProductParameterHolder productParameterHolder;

  @override
  _MapFilterViewState createState() => _MapFilterViewState();
}

class _MapFilterViewState extends State<GoogleMapFilterView>
    with TickerProviderStateMixin {
  List<String> seekBarValues = <String>[
    '0.5',
    '1',
    '2.5',
    '5',
    '10',
    '25',
    '50',
    '100',
    '200',
    '500',
    'All'
  ];
  LatLng? latlng;
  final double zoom = 10;
  double radius = -1;
  double defaultRadius = 3000;
  bool isRemoveCircle = false;
  String address = '';
  bool isFirst = true;
  late CameraPosition kGooglePlex;
  GoogleMapController? mapController;
  late PsValueHolder valueHolder;

  // dynamic loadAddress() async {
  //   try {
  //     final Address locationAddress = await GeoCode().reverseGeocoding(
  //         latitude: latlng!.latitude,
  //         longitude: latlng!.longitude);

  //     address =
  //         '${locationAddress.streetAddress}  \n, ${locationAddress.countryName}';
  //   } catch (e) {
  //     address = '';
  //     print(e);
  //   }
  // }

  Future<void> loadAddress() async {
      await placemarkFromCoordinates(
              latlng!.latitude,
              latlng!.longitude)
          .then((List<Placemark> placemarks) {
        final Placemark place = placemarks[0];
        setState(() {
          address =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        });
      }).catchError((dynamic e) {
        debugPrint(e);
      });
    }

  double _value = 0.3;
  String kmValue = '5';

  int findTheIndexOfTheValue(String? value) {
    int index = 0;

    for (int i = 0; i < seekBarValues.length - 1; i++) {
      if (!(value == 'All')) {
        if (getMiles(seekBarValues[i]) == value) {
          index = i;
          break;
        }
      } else {
        index = seekBarValues.length - 1;
      }
    }

    return index;
  }

  String getMiles(String kmValue) {
    final double _km = double.parse(kmValue);
    return (_km * 0.621371).toStringAsFixed(3);
  }

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    latlng ??= LatLng(double.parse(widget.productParameterHolder.lat!),
        double.parse(widget.productParameterHolder.lng!));

    if (widget.productParameterHolder.mile != '' && isFirst) {
      final int _index =
          findTheIndexOfTheValue(widget.productParameterHolder.mile);
      kmValue = seekBarValues[_index];
      final double _val = double.parse(getMiles(kmValue)) * 1000;
      radius = _val;
      defaultRadius = radius;
      _value = _index / 10;
      isFirst = false;
    }

    final double scale = defaultRadius / 300; //radius/20
    final double value = 16 - log(scale) / log(2);
    loadAddress();

    kGooglePlex = CameraPosition(
      target: LatLng(double.parse(widget.productParameterHolder.lat!),
          double.parse(widget.productParameterHolder.lng!)),
      zoom: value,
    );

    print('value $value');

    return PsWidgetWithAppBarWithNoProvider(
        appBarTitle: Utils.getString(context, 'map_filter__title'),
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Flexible(
                child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: kGooglePlex,
                    circles: <Circle>{}..add(Circle(
                        circleId: CircleId(address),
                        center: latlng!,
                        radius: isRemoveCircle == true
                            ? 0.0
                            : radius <= 0.0
                                ? defaultRadius
                                : radius,
                        fillColor: Colors.blue.withOpacity(0.7),
                        strokeWidth: 3,
                        strokeColor: Utils.isLightMode(context) ? PsColors.primary500 : PsColors.primary50,
                      )),
                    onTap: _handleTap),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: PsDimens.space8,
                ),
                child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      Utils.getString(context, 'map_filter__browsing'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _value == 1
                      ? seekBarValues[(_value * 10).toInt()]
                      : seekBarValues[(_value * 10).toInt()] +
                          Utils.getString(context, 'map_filter__km'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                child: Slider(
                  activeColor: PsColors.activeColor,
                  value: _value,
                  onChanged: (double newValue) {
                    setState(() {
                      _value = newValue;
                      kmValue = seekBarValues[(_value * 10).toInt()];
                      if (kmValue == 'All') {
                        isRemoveCircle = true;
                      } else {
                        radius = double.parse(getMiles(kmValue)) *
                            1000; //_value * 10000;
                      }
                      _value == 1
                          ? isRemoveCircle = true
                          : isRemoveCircle = false;
                      defaultRadius != 0
                          ? defaultRadius = 500
                          : defaultRadius = 500;
                    });
                  },
                  divisions: 10,
                  label: _value == 1
                      ? seekBarValues[(_value * 10).toInt()]
                      : seekBarValues[(_value * 10).toInt()] +
                          Utils.getString(context, 'map_filter__km'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: PsDimens.space8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      Utils.getString(context, 'map_filter__lowest_km'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Utils.getString(context, 'map_filter__all'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
               Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: <Widget>[
                   Container(
                     width: 140,
                     child: PSButtonWidgetWithIconRoundCorner(
                      hasShadow: false,
                       colorData: PsColors.baseColor,
                       titleText: Utils.getString(context, 'map_filter__reset'),
                       onPressed: (){
                            setState(() {
                             isRemoveCircle = true;
                             _value = 1.0;
                           });
                       },
                     ),
                   ),
                   Container(
                     width: 140,
                     child: PSButtonWidgetWithIconRoundCorner(
                      hasShadow: false,
                      colorData: PsColors.buttonColor,
                       titleText: Utils.getString(context, 'map_filter__apply'),
                       onPressed: (){
                             if (kmValue == 'All') {
                               widget.productParameterHolder.lat = '';
                               widget.productParameterHolder.lng = '';
                               widget.productParameterHolder.mile = '';
                               if (valueHolder.isSubLocation == PsConst.ONE) {
                                 widget.productParameterHolder.itemLocationId = '';
                               } else {
                                 widget.productParameterHolder.itemLocationId = '';
                                 widget.productParameterHolder.itemLocationTownshipId = '';
                               }
                             } else {
                               widget.productParameterHolder.lat = latlng!.latitude.toString();
                               widget.productParameterHolder.lng = latlng!.longitude.toString();
                               widget.productParameterHolder.mile = getMiles(kmValue);
                             }
                             Navigator.pop(context, widget.productParameterHolder);
                                      },
                     ),
                   )
                          ],
                        ),
            ],
          ),
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _handleTap(LatLng latlng) {
    setState(() {
      this.latlng = latlng;
    });
  }
}
