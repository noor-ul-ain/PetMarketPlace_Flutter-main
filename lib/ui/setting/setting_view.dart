import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/ui/common/ps_admob_banner_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:theme_manager/theme_manager.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key, required this.animationController})
      : super(key: key);
  final AnimationController? animationController;
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && valueHolder.isShowAdmob!) {
        // setState(() {});
      }
    });
  }
  late PsValueHolder valueHolder;

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    valueHolder = Provider.of<PsValueHolder>(context, listen: false);
    if (!isConnectedToInternet && valueHolder.isShowAdmob!) {
      print('loading ads....');
      checkConnection();
    }
    widget.animationController!.forward();
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: widget.animationController!,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));
    return AnimatedBuilder(
      animation: widget.animationController!,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _SettingPrivacyWidget(),
            const SizedBox(height: PsDimens.space8),
            _SettingTermsAndConditionsWidget(),
            const SizedBox(height: PsDimens.space8),
            _SettingFAQWidget(),
            const SizedBox(height: PsDimens.space8),
            _SettingNotificationWidget(),
            const SizedBox(height: PsDimens.space8),
            // _CameraSettingWidget(),
            // const SizedBox(height: PsDimens.space8),
            _IntroSliderWidget(),
            const SizedBox(height: PsDimens.space8),
            _SettingDarkAndWhiteModeWidget(
                animationController: widget.animationController),
            const SizedBox(height: PsDimens.space8),
            _SettingAppInfoWidget(),
            const SizedBox(height: PsDimens.space8),
            _SettingAppVersionWidget(),
            const PsAdMobBannerWidget(
              admobSize: AdSize.mediumRectangle,
              // admobBannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
            ),
          ],
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 100 * (1.0 - animation.value), 0.0),
              child: child),
        );
      },
    );
  }
}

class _SettingAppInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('App Info');
        Navigator.pushNamed(context, RoutePaths.appinfo, arguments: 1);
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'setting__app_info'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: PsDimens.space10,
                  ),
                  Text(
                    Utils.getString(context, 'setting__app_info'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: PsColors.iconColor,
                size: PsDimens.space12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingPrivacyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('App Info');
        Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 1);
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'setting__privacy_policy'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: PsDimens.space10,
                  ),
                  Text(
                    Utils.getString(context, 'setting__policy_statement'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: PsColors.iconColor,
                size: PsDimens.space12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingTermsAndConditionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('App Info');
        Navigator.pushNamed(context, RoutePaths.termsAndCondition);
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'setting__terms_and_condition'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: PsDimens.space10,
                  ),
                  Text(
                    Utils.getString(context, 'setting__terms_and_condition_statement'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: PsColors.iconColor,
                size: PsDimens.space12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingFAQWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('App Info');
        Navigator.pushNamed(context, RoutePaths.faq);
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'setting__faq'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: PsDimens.space10,
                  ),
                  Text(
                    Utils.getString(context, 'setting__faq_statement'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: PsColors.iconColor,
                size: PsDimens.space12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CameraSettingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Camera Setting');
        Navigator.pushNamed(context, RoutePaths.cameraSetting);
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'setting__camera_setting'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: PsDimens.space10,
                  ),
                  Text(
                    Utils.getString(context, 'setting__camera_control_setting'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: PsColors.iconColor,
                size: PsDimens.space12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroSliderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Slider Guide');
        Navigator.pushNamed(context, RoutePaths.introSlider, arguments: 1);
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'intro_slider_setting'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: PsDimens.space10,
                  ),
                  Text(
                    Utils.getString(
                        context, 'intro_slider_setting_description'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: PsColors.iconColor,
                size: PsDimens.space12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingNotificationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Notification Setting');
        Navigator.pushNamed(context, RoutePaths.notiSetting);
      },
      child: Container(
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Ink(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Utils.getString(context, 'setting__notification_setting'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: PsDimens.space10,
                  ),
                  Text(
                    Utils.getString(context, 'setting__control_setting'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: PsColors.iconColor,
                size: PsDimens.space12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingDarkAndWhiteModeWidget extends StatefulWidget {
  const _SettingDarkAndWhiteModeWidget({Key? key, this.animationController})
      : super(key: key);
  final AnimationController? animationController;
  @override
  __SettingDarkAndWhiteModeWidgetState createState() =>
      __SettingDarkAndWhiteModeWidgetState();
}

class __SettingDarkAndWhiteModeWidgetState
    extends State<_SettingDarkAndWhiteModeWidget> {
  bool checkClick = false;
  bool isDarkOrWhite = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: PsColors.baseColor,
        padding: const EdgeInsets.only(
            left: PsDimens.space16,
            bottom: PsDimens.space12,
            right: PsDimens.space12,
            top: PsDimens.space12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(
                Utils.getString(context, 'setting__change_mode'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (checkClick)
              Switch(
                value: isDarkOrWhite,
                onChanged: (bool value) {
                  setState(() {
                    PsColors.loadColor2(value);
                    isDarkOrWhite = value;
                    changeBrightness(context);
                  });
                },
                activeTrackColor: PsColors.primary500,
                activeColor: PsColors.primary500,
              )
            else
              Switch(
                value: isDarkOrWhite,
                onChanged: (bool value) {
                  setState(() {
                    PsColors.loadColor2(value);
                    isDarkOrWhite = value;
                    changeBrightness(context);
                  });
                },
                activeTrackColor: PsColors.iconColor,
                activeColor: PsColors.iconColor,
              ),
          ],
        ));
  }
}

void changeBrightness(BuildContext context) {
  ThemeManager.of(context).setBrightnessPreference(Utils.isLightMode(context)
      ? BrightnessPreference.dark
      : BrightnessPreference.light);
}

class _SettingAppVersionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('App Info');
      },
      child: Container(
        width: double.infinity,
        color: PsColors.baseColor,
        padding: const EdgeInsets.all(PsDimens.space16),
        child: Ink(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                Utils.getString(context, 'setting__app_version'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: PsDimens.space10,
              ),
              Text(
                PsConfig.app_version,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
