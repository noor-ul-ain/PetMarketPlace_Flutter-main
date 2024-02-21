import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class PsAdMobBannerWidget extends StatefulWidget {
  const PsAdMobBannerWidget({this.admobSize = AdSize.banner, this.useSliver = false});
  final bool useSliver;
  final AdSize admobSize;

  @override
  _PsAdMobBannerWidgetState createState() => _PsAdMobBannerWidgetState();
}

class _PsAdMobBannerWidgetState extends State<PsAdMobBannerWidget> {
  bool showAds = false;
  bool isConnectedToInternet = false;
  int currentRetry = 0;
  int retryLimit = 1;

  late BannerAd _bannerAd;
  double height = 0;
  late PsValueHolder psValueHolder;

  @override
  void initState() {
    _bannerAd = BannerAd(
      adUnitId: Utils.getBannerAdUnitId(),
      request: const AdRequest(),
      size: widget.admobSize,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          showAds = true;
          setState(() {
            if (widget.admobSize == AdSize.banner) {
              height = 60;
            } else {
              height = 250;
            }
          });
          print('loaded');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          showAds = false;
        },
        onAdOpened: (Ad ad) {
          print('$BannerAd onAdOpened.');
        },
        onAdClosed: (Ad ad) {
          print('$BannerAd onAdClosed.');
        },
      ),
    );
    _bannerAd.load();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getAdmobWidget() {
    if (showAds && psValueHolder.isShowAdmob!)
      return Container(
        alignment: Alignment.center,
        child: AdWidget(ad: _bannerAd),
        width: _bannerAd.size.width.toDouble(),
        height: _bannerAd.size.height.toDouble(),
      );
    else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    psValueHolder = Provider.of<PsValueHolder>(context);
    return widget.useSliver
        ? SliverToBoxAdapter(child: getAdmobWidget())
        : getAdmobWidget();
  }
}
