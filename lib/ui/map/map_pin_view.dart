import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget_with_round_corner.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/map_pin_call_back_holder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class MapPinView extends StatefulWidget {
  const MapPinView(
      {required this.flag, required this.maplat, required this.maplng});

  final String flag;
  final String? maplat;
  final String? maplng;

  @override
  _MapPinViewState createState() => _MapPinViewState();
}

class _MapPinViewState extends State<MapPinView> with TickerProviderStateMixin {
  LatLng? latlng;
  double defaultRadius = 3000;
  String address = '';

  // dynamic loadAddress() async {
  //   try {
  //     final Address locationAddress = await GeoCode().reverseGeocoding(
  //         latitude: latlng!.latitude, longitude: latlng!.longitude);

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
        debugPrint(e.toString());
      });
    }

  @override
  Widget build(BuildContext context) {
    latlng ??=
        LatLng(double.parse(widget.maplat!), double.parse(widget.maplng!));

    const double value = 16.0;
    // 16 - log(scale) / log(2);
    loadAddress();

    print('value $value');

    return PsWidgetWithAppBarWithNoProvider(
        appBarTitle: Utils.getString(context, 'location_tile__title'),
        // actions: widget.flag == PsConst.PIN_MAP
        //     ? <Widget>[
        //         InkWell(
        //           child: Ink(
        //             child: Center(
        //               child: Text(
        //                 Utils.getString(context, 'map_pin__pick_location'),
        //                 textAlign: TextAlign.justify,
        //                 style: Theme.of(context)
        //                     .textTheme
        //                     .bodyText2!
        //                     .copyWith(fontWeight: FontWeight.bold)
        //                     .copyWith(color: PsColors.primaryDarkWhite),
        //               ),
        //             ),
        //           ),
        //           onTap: () {
        //             Navigator.pop(context,
        //                 MapPinCallBackHolder(address: address, latLng: latlng));
        //           },
        //         ),
        //         const SizedBox(
        //           width: PsDimens.space16,
        //         ),
        //       ]
        //     : <Widget>[],
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              // Flexible(
              //   child:
                 FlutterMap(
                  options: MapOptions(
                      center:
                          latlng, //LatLng(51.5, -0.09), //LatLng(45.5231, -122.6765),
                      zoom: value, //10.0,
                      onTap: widget.flag == PsConst.PIN_MAP
                          ? _handleTap
                          : _doNothingTap),
                  children: <Widget>[
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    // MarkerLayerOptions(markers: <Marker>[
                    //   Marker(
                    //     width: 80.0,
                    //     height: 80.0,
                    //     point: latlng,
                    //     builder: (BuildContext ctx) => Container(
                    //       child: IconButton(
                    //         icon: Icon(
                    //           Icons.location_on,
                    //           color: PsColors.primary500,
                    //         ),
                    //         iconSize: 45,
                    //         onPressed: () {},
                    //       ),
                    //     ),
                    //   ),
                    // ]),
                    CircleLayer(
                      circles: <CircleMarker>[
                        CircleMarker(
                            point: latlng!,
                            color: Colors.blue.withOpacity(0.7),
                            borderStrokeWidth: 2,
                            useRadiusInMeter: true,
                            radius: 200),
                      ],
                    ),
                  ],
                ),
              //),
              Positioned(
                bottom: 2,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  // margin: const EdgeInsets.only(
                  //      left: PsDimens.space20,
                  //      bottom: PsDimens.space10
                  //      ),
                  child: PSButtonWidgetRoundCorner(
                    colorData: PsColors.buttonColor,
                    hasShadow: false,
                   // width: PsDimens.space60,
                    titleText: Utils.getString(context, 'map_pin__pick_location'),
                    onPressed: () {
                      Navigator.pop(context,
                          MapPinCallBackHolder(address: address, latLng: latlng));
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void _handleTap(dynamic tapPosition, LatLng latlng) {
    setState(() {
      this.latlng = latlng;
    });
  }

  void _doNothingTap(dynamic tapPosition, LatLng latlng) {}
}
