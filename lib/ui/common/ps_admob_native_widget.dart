import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PsAdMobNativeWidget extends StatefulWidget {
  const PsAdMobNativeWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<PsAdMobNativeWidget> createState() => _PsAdMobNativeWidgetState();
}

class _PsAdMobNativeWidgetState extends State<PsAdMobNativeWidget> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _nativeAd = NativeAd(
      adUnitId: Utils.getNativeAdUnitId(),
      request: const AdRequest(),
      factoryId: Platform.isAndroid ? 'adFactoryExample' : 'listTile',
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
      ),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space4,
                right: PsDimens.space4,
                bottom: PsDimens.space12),
            decoration: BoxDecoration(
              color: PsColors.white,
              borderRadius:
                  const BorderRadius.all(Radius.circular(PsDimens.space8)),
            ),
            width: 180,
            child: _nativeAdIsLoaded ? AdWidget(ad: _nativeAd!) : const Text('Loading Ads'));
  }
}
