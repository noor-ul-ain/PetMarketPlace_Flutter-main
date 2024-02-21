// Copyright (c) 2019, the PS Project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// PS license that can be found in the LICENSE file.




import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

/// Colors Config For the whole App
/// Please change the color based on your brand need.

///
/// Dark Theme
///
// const Color ps_wtheme_color_primary = Color(0xFFFFFFFF);
// const Color ps_wtheme_color_primary_dark = Color(0xfFC7D180);
// const Color ps_wtheme_color_primary_light = Color(0xfEFAD670);

// const Color ps_wtheme_text__primary_color = Color(0xFF656565);
// const Color ps_wtheme_text__primary_light_color = Color(0xFFadadad);
// const Color ps_wtheme_text__primary_dark_color = Color(0xFF424242);

// const Color ps_wtheme_icon_color = Color(0xFF757575);
// const Color ps_wtheme_white_color = Colors.white;

// ///
// /// White Theme
// ///
// const Color ps_dtheme_color_primary = Color(0xFF303030);
// const Color ps_dtheme_color_primary_dark = Color(0xFF555555);
// const Color ps_dtheme_color_primary_light = Color(0xFF555555);

// const Color ps_dtheme_text__primary_color = Color(0xFFFFFFFF);
// const Color ps_dtheme_text__primary_light_color = Color(0xFFFFFFFF);
// const Color ps_dtheme_text__primary_dark_color = Color(0xFFFFFFFF);

// const Color ps_dtheme_icon_color = Colors.white;
// const Color ps_dtheme_white_color = Color(0xFF757575);

// ///
// /// Common Theme
// ///
// const Color ps_ctheme_text__category_title = Color(0xFFffcc00);
// const Color ps_ctheme_button__category_title = Color(0xFFffcc00);
// const Color ps_ctheme_text__color_gery = Color(0xFF757575);
// const Color ps_ctheme_text__color_primary_light = Color(0xFFbdbdbd);
// const Color ps_ctheme__color_speical = Color(0xFFD2232A);
// const Color ps_ctheme__color_about_us = Colors.cyan;
// const Color ps_ctheme__color_application = Colors.blue;
// const Color ps_ctheme__color_line = Color(0xFFbdbdbd);
// const Color ps_ctheme__sold_out = Color(0x80D2232A);
// const Color ps_ctheme__global_primary = Color(0xFFD2232A);

// Copyright (c) 2019, the PS Project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// PS license that can be found in the LICENSE file.

// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutterbuyandsell/utils/utils.dart';

class PsColors {
  PsColors._();

  ///
  /// Main Color
  ///



  static Color mainLightColorWithBlack = _d_base_color;
  static Color mainShadowColor = Colors.black.withOpacity(0.5);
  static Color mainLightShadowColor  = Colors.black.withOpacity(0.5);
  static Color mainDividerColor = _d_divider_color;


  /// Primary Color
  static Color primary50 = _c_primary_50;
  static Color primary100 = _c_primary_100;
  static Color primary200 = _c_primary_200;
  static Color primary300 = _c_primary_300;
  static Color primary400 = _c_primary_400;
  static Color primary500 = _c_primary_500;
  static Color primary600 = _c_primary_600;
  static Color primary700 = _c_primary_700;
  static Color primary800 = _c_primary_800;
  static Color primary900 = _c_primary_900;
   
  /// Primary Dark Color
  static Color primaryDarkDark = _c_primary_dark_dark;
  static Color primaryDarkAccent = _c_primary_dark_accent;
  static Color primaryDarkWhite = _c_primary_dark_white;
  static Color primaryDarkGrey = _c_primary_dark_grey;


  /// Secondary Color
  static Color secondary50 = _c_secondary_50;
  static Color secondary100 = _c_secondary_100;
  static Color secondary200 = _c_secondary_200;
  static Color secondary300 = _c_secondary_300;
  static Color secondary400 = _c_secondary_400;
  static Color secondary500 = _c_secondary_500;
  static Color secondary600 = _c_secondary_600;
  static Color secondary700 = _c_secondary_700;
  static Color secondary800 = _c_secondary_800;
  static Color secondary900 = _c_secondary_900;

  /// Secondary Dark Color
  static Color secondaryDarkDark = _c_secondary_dark_dark;
  static Color secondaryDarkAccent = _c_secondary_dark_accent;
  static Color secondaryDarkWhite = _c_secondary_dark_white;
  static Color secondaryDarkGrey = _c_secondary_dark_grey;

  ///
  /// Base Color
  ///
  static Color baseColor = _d_base_color;
  static Color baseDarkColor = _d_base_dark_color;
  static Color baseLightColor = _d_base_light_color;

  ///
  /// Text Color
  ///
  static Color textPrimaryColor = _d_text_primary_color;
  static Color textPrimaryDarkColor = _d_text_primary_dark_color;
  static Color textPrimaryLightColor = _d_text_primary_light_color;

  static Color? textPrimaryColorForLight;
  static Color? textPrimaryDarkColorForLight;
  static Color? textPrimaryLightColorForLight;

  static Color? textColor1;
  static Color? textColor2;
  static Color? textColor3;
  static Color? textColor4;

  ///
  /// Button Color
  ///
  static Color? buttonColor;
  static Color? bottomNavigationSelectedColor;
  static Color? backArrowColor;

  ///
  /// Primary Color
  ///
  static Color? activeColor;

  ///
  /// Icon Color
  ///
    static Color iconColor = _d_icon_color;
  ///
  /// Background Color
  ///
  static Color coreBackgroundColor = _d_base_color;
  static Color backgroundColor = _d_base_dark_color;

  ///
  /// General
  ///
  static Color white = _c_white_color;
  static Color black = _c_black_color;
  static Color grey = _c_grey_color;
  static Color transparent = _c_transparent_color;
  
  ///
  /// Customs
  ///

  static Color facebookLoginButtonColor = _c_facebook_login_color;
  static Color googleLoginButtonColor = _c_google_login_color;
  static Color phoneLoginButtonColor = _c_phone_login_color;
  static Color appleLoginButtonColor  = _c_apple_login_color;
  static Color disabledFacebookLoginButtonColor = _c_grey_color;
  static Color disabledGoogleLoginButtonColor = _c_grey_color;
  static Color disabledPhoneLoginButtonColor = _c_grey_color;
  static Color disabledAppleLoginButtonColor = _c_grey_color;

  static Color? paypalColor;
  static Color? stripeColor;

  static Color? categoryBackgroundColor;
  static Color? cardBackgroundColor;
  static Color? loadingCircleColor;
  static Color? ratingColor;

  static Color? soldOutUIColor;
  static Color? itemTypeColor;

  static Color? paidAdsColor;

  static Color? bluemarkColor;

  /// Colors Config For the whole App
  /// Please change the color based on your brand need.

  ///
  /// Light Theme
  ///
  // static const Color _l_base_color = Color(0xFEF7F7F7);
  static const Color _l_base_color = Color(0xFFffffff);
  static const Color _l_base_dark_color = Color(0xFFFFFFFF);
  static const Color _l_base_light_color = Color(0xFFEFEFEF);

  static const Color _l_text_primary_color = Color(0xFF445E76);
  static const Color _l_text_primary_light_color = Color(0xFFadadad);
  static const Color _l_text_primary_dark_color = Color(0xFF25425D);

  static const Color _l_icon_color = PsColors._c_primary_500;

  static const Color _l_divider_color = Color(0x15505050);


  ///
  /// Dark Theme
  ///
  static const Color _d_base_color = Color(0xFF212121);
  static const Color _d_base_dark_color = Color(0xFF303030);
  static const Color _d_base_light_color = Color(0xFF454545);

  static const Color _d_text_primary_color = Color(0xFFFFFFFF);
  static const Color _d_text_primary_light_color = Color(0xFFFFFFFF);
  static const Color _d_text_primary_dark_color = Color(0xFFFFFFFF);

  static const Color _d_icon_color = PsColors._c_primary_dark_accent;

  static const Color _d_divider_color = Color(0x1FFFFFFF);

  ///
  /// Common Theme
  ///
  // static const Color _c_main_color = Color(0xFFD31A20);
  // static const Color _c_main_light_color = Color(0xFFFFF0F1);
  // static const Color _c_main_dark_color = Color(0xFF95292C);

  /// Primary Color
  static const Color _c_primary_50  =  Color(0xFFf5e5e5);
  static const Color _c_primary_100 = Color(0xFFe5bdbf);
  static const Color _c_primary_200 = Color(0xFFd49294);
  static const Color _c_primary_300 = Color(0xFFc36669);
  static const Color _c_primary_400 = Color(0xFFb64548);
  static const Color _c_primary_500 = Color(0xFFa92428);
  static const Color _c_primary_600 = Color(0xFFa22024);
  static const Color _c_primary_700 = Color(0xFF981b1e);
  static const Color _c_primary_800 = Color(0xFF8f1618);
  static const Color _c_primary_900 = Color(0xFF7e0d0f);

  static const Color _c_primary_dark_dark = Color(0xFF303030);
  static const Color _c_primary_dark_accent = Color(0xFFffb0b1);
  static const Color _c_primary_dark_white = Color(0xFFffffff);
  static const Color _c_primary_dark_grey = Color(0xFFA0A0A0);

  /// Secondary Color 
  static const Color _c_secondary_50  =  Color(0xFFe5e9ec);
  static const Color _c_secondary_100 = Color(0xFFbdc7d0);
  static const Color _c_secondary_200 = Color(0xFF92a2b0);
  static const Color _c_secondary_300 = Color(0xFF667c90);
  static const Color _c_secondary_400 = Color(0xFF456079);
  static const Color _c_secondary_500 = Color(0xFF244461);
  static const Color _c_secondary_600 = Color(0xFF203e59);
  static const Color _c_secondary_700 = Color(0xFF1b354f);
  static const Color _c_secondary_800 = Color(0xFF162d45);
  static const Color _c_secondary_900 = Color(0xFF0d1f33);

  static const Color _c_secondary_dark_dark = Color(0xFF303030);
  static const Color _c_secondary_dark_accent = Color(0xFF6facff);
  static const Color _c_secondary_dark_white = Color(0xFFffffff);
  static const Color _c_secondary_dark_grey = Color(0xFFA0A0A0);

  static const Color _c_white_color = Colors.white;
  static const Color _c_black_color = Colors.black;
  static const Color _c_grey_color = Colors.grey;
  static const Color _c_blue_color = Colors.blue;
  static const Color _c_transparent_color = Colors.transparent;
  static const Color _c_paid_ads_color = Colors.lightGreen;

  static const Color _c_facebook_login_color = Color(0xFF2153B2);
  static const Color _c_google_login_color = Color(0xFFFF4D4D);
  static const Color _c_phone_login_color = Color(0xFF9F7A2A);
  static const Color _c_apple_login_color = Color(0xFF111111);

  static const Color _c_paypal_color = Color(0xFF3b7bbf);
  static const Color _c_stripe_color = Color(0xFF008cdd);

  static const Color _c_rating_color = Colors.yellow;
  static const Color _c_sold_out = Color(0x80D2232A);
  static const Color _c_item_type_color = Color(0xFFBDBDBD);

  // static const Color ps_ctheme__color_about_us = Colors.cyan;
  // static const Color ps_ctheme__color_application = Colors.blue;
  // static const Color ps_ctheme__color_line = Color(0xFFbdbdbd);

  static void loadColor(BuildContext context) {
    if (Utils.isLightMode(context)) {
      _loadLightColors();
    } else {
      _loadDarkColors();
    }
  }

  static void loadColor2(bool isLightMode) {
    if (isLightMode) {
      _loadLightColors();
    } else {
      _loadDarkColors();
    }
  }

  static void _loadDarkColors() {
    ///
    /// Main Color
    ///
    mainLightColorWithBlack = _d_base_color;
    mainShadowColor = Colors.black.withOpacity(0.5);
    mainLightShadowColor = Colors.black.withOpacity(0.5);
    mainDividerColor = _d_divider_color;

    ///
    ///Primary dark Color
    ///
    primaryDarkDark = _c_primary_dark_dark;
    primaryDarkAccent = _c_primary_dark_accent;
    primaryDarkWhite = _c_primary_dark_white;
    primaryDarkGrey = _c_primary_dark_grey;

    ///
    ///Secondary dark Color
    ///
    secondaryDarkDark = _c_secondary_dark_dark;
    secondaryDarkAccent = _c_secondary_dark_accent;
    secondaryDarkWhite = _c_secondary_dark_white;
    secondaryDarkGrey = _c_secondary_dark_grey;

    ///
    /// Base Color
    ///
    baseColor = _d_base_color;
    baseDarkColor = _d_base_dark_color;
    baseLightColor = _d_base_light_color;

    ///
    /// Text Color
    ///
    textPrimaryColor = _d_text_primary_color;
    textPrimaryDarkColor = _d_text_primary_dark_color;
    textPrimaryLightColor = _d_text_primary_light_color;

    textPrimaryColorForLight = _l_text_primary_color;
    textPrimaryDarkColorForLight = _l_text_primary_dark_color;
    textPrimaryLightColorForLight = _l_text_primary_light_color;

    textColor1 = const Color(0xFFffb0b1); 
    textColor2 = const Color(0xFFffffff);
    textColor3 = const Color(0xFFA0A0A0);
    textColor4 = const Color(0xFF212121);

    ///
    /// Button Color
    ///
    buttonColor = const Color(0xFFffb0b1);
    bottomNavigationSelectedColor = const Color(0xFFffb0b1);
    activeColor = const Color(0xFFffb0b1);
    backArrowColor = const Color(0xFFffb0b1);

    ///
    /// Icon Color
    ///
    iconColor = _d_icon_color;

    ///
    /// Background Color
    ///
    coreBackgroundColor = _d_base_color;
    backgroundColor = _d_base_dark_color;

    ///
    /// General
    ///
    white = _c_white_color;
    black = _c_black_color;
    grey = _c_grey_color;
    transparent = _c_transparent_color;

    ///
    /// Custom
    ///
    facebookLoginButtonColor = _c_facebook_login_color;
    googleLoginButtonColor = _c_google_login_color;
    appleLoginButtonColor = _c_apple_login_color;
    phoneLoginButtonColor = _c_phone_login_color;
    disabledFacebookLoginButtonColor = _c_grey_color;
    disabledGoogleLoginButtonColor = _c_grey_color;
    disabledAppleLoginButtonColor = _c_grey_color;
    disabledPhoneLoginButtonColor = _c_grey_color;
    paypalColor = _c_paypal_color;
    stripeColor = _c_stripe_color;
    categoryBackgroundColor = _d_base_light_color;
    loadingCircleColor = _c_blue_color;
    ratingColor = _c_rating_color;
    soldOutUIColor = _c_sold_out;
    itemTypeColor = _c_item_type_color;
    paidAdsColor = _c_paid_ads_color;
    bluemarkColor = _c_blue_color;
    cardBackgroundColor = _c_primary_dark_dark;
  }

  static void _loadLightColors() {
    ///
    /// Main Color
    mainDividerColor = _l_divider_color;

    ///
    ///Primary Color
    ///
    primary50 = _c_primary_50;
    primary100 = _c_primary_100;
    primary200 = _c_primary_200;
    primary300 = _c_primary_300;
    primary400 = _c_primary_400;
    primary500 = _c_primary_500;
    primary600 = _c_primary_600;
    primary700 = _c_primary_700;
    primary800 = _c_primary_800;
    primary900 = _c_primary_900;


    ///
    ///Secondary Color
    ///
    secondary50 = _c_secondary_50;
    secondary100 = _c_secondary_100;
    secondary200 = _c_secondary_200;
    secondary300 = _c_secondary_300;
    secondary400 = _c_secondary_400;
    secondary500 = _c_secondary_500;
    secondary600 = _c_secondary_600;
    secondary700 = _c_secondary_700;
    secondary800 = _c_secondary_800;
    secondary900 = _c_secondary_900;
    
    

    ///
    /// Base Color
    ///
    baseColor = _l_base_color;
    baseDarkColor = _l_base_dark_color;
    baseLightColor = _l_base_light_color;

    ///
    /// Text Color
    ///
    textPrimaryColor = _l_text_primary_color;
    textPrimaryDarkColor = _l_text_primary_dark_color;
    textPrimaryLightColor = _l_text_primary_light_color;

    textPrimaryColorForLight = _l_text_primary_color;
    textPrimaryDarkColorForLight = _l_text_primary_dark_color;
    textPrimaryLightColorForLight = _l_text_primary_light_color;

    textColor1 = const Color(0xFFa92428); 
    textColor2 = const Color(0xFF244461);
    textColor3 = const Color(0xFF456079);
    textColor4 = const Color(0xFFffffff);

    ///
    /// Button Color
    ///
    buttonColor = const Color(0xFFa92428);
    bottomNavigationSelectedColor = const Color(0xFFa92428);
    activeColor = const Color(0xFFa92428);
    backArrowColor = const Color(0xFFa92428);

    ///
    /// Icon Color
    ///
    iconColor = _l_icon_color;

    ///
    /// Background Color
    ///
    coreBackgroundColor = _l_base_color;
    backgroundColor = _l_base_dark_color;

    ///
    /// General
    ///
    white = _c_white_color;
    black = _c_black_color;
    grey = _c_grey_color;
    transparent = _c_transparent_color;

    ///
    /// Custom
    ///
    facebookLoginButtonColor = _c_facebook_login_color;
    googleLoginButtonColor = _c_google_login_color;
    appleLoginButtonColor = _c_apple_login_color;
    phoneLoginButtonColor = _c_phone_login_color;
    disabledFacebookLoginButtonColor = _c_grey_color;
    disabledGoogleLoginButtonColor = _c_grey_color;
    disabledAppleLoginButtonColor = _c_grey_color;
    disabledPhoneLoginButtonColor = _c_grey_color;
    paypalColor = _c_paypal_color;
    stripeColor = _c_stripe_color;
    loadingCircleColor = _c_blue_color;
    ratingColor = _c_rating_color;
    soldOutUIColor = _c_sold_out;
    itemTypeColor = _c_item_type_color;
    paidAdsColor = _c_paid_ads_color;
    cardBackgroundColor = _c_primary_50;
  }
}
