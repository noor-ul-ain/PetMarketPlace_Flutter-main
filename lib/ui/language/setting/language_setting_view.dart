


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/language/language_provider.dart';
import 'package:flutterbuyandsell/repository/language_repository.dart';
import 'package:flutterbuyandsell/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_dropdown_base_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/language.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class LanguageSettingView extends StatefulWidget {
  const LanguageSettingView(
      {Key? key,
      required this.animationController,
       this.languageIsChanged})
      : super(key: key);
  final AnimationController? animationController;
  final Function? languageIsChanged;
  @override
  _LanguageSettingViewState createState() => _LanguageSettingViewState();
}

class _LanguageSettingViewState extends State<LanguageSettingView> {
  String currentLang = '';
  LanguageRepository? repo1;

  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && true) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && true) {
      print('loading ads....');
      checkConnection();
    }
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    widget.animationController!.forward();
    // final dynamic data = EasyLocalizationProvider.of(context).data;
    final LanguageRepository repo1 = Provider.of<LanguageRepository>(context);
    // return EasyLocalizationProvider(
    //   data: data,
    //   child:
    return ChangeNotifierProvider<LanguageProvider>(
      lazy: false,
      create: (BuildContext context) {
        final LanguageProvider provider = LanguageProvider(repo: repo1);
      //  provider.getLanguageList();
        return provider;
      },
      child: Consumer<LanguageProvider>(builder:
          (BuildContext context, LanguageProvider provider, Widget? child) {
        return AnimatedBuilder(
            animation: widget.animationController!,
            child: SingleChildScrollView(
                child: Container(
              padding: const EdgeInsets.all(PsDimens.space8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  PsDropdownBaseWidget(
                      title: Utils.getString(
                          context, 'language_selection__select'),
                      selectedText: provider.getLanguage().name,
                      onTap: () async {
                        //provider.getLanguageList(); 
                        final dynamic result = await Navigator.pushNamed(
                            context, RoutePaths.languageList);  
                        if (result != null && result is Language) {
                          // EasyLocalization.of(context).set
                          // await data.changeLocale(result.toLocale());

                          // EasyLocalization.of(context).

                         await provider.addLanguage(result);
                         EasyLocalization.of(context)?.setLocale( Locale(result.languageCode!, result.countryCode));
                        }
                        Utils.psPrint(result.toString());
                      }),
                  const PsAdMobBannerWidget(
                    admobSize: AdSize.mediumRectangle,
                    // admobBannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                  ),
                ],
              ),
            )),
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                  opacity: animation,
                  child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 100 * (1.0 - animation.value), 0.0),
                      child: child));
            });
      }),
      // ),
    );
  }
}
