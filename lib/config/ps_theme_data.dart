import 'package:flutter/material.dart';
import 'ps_colors.dart';
import 'ps_config.dart';

ThemeData themeData(ThemeData baseTheme) {
  //final baseTheme = ThemeData.light();

  if (baseTheme.brightness == Brightness.dark) {
    PsColors.loadColor2(false);

    // Dark Theme
    return baseTheme.copyWith(
      primaryColor: PsColors.primary500,
      primaryColorDark: PsColors.baseColor,
      primaryColorLight: PsColors.primaryDarkWhite,
      textTheme: TextTheme(
        displayLarge: TextStyle(
            color: PsColors.primaryDarkWhite,
            fontFamily: PsConfig.ps_default_font_family),
        displayMedium: TextStyle(
            color: PsColors.primaryDarkWhite,
            fontFamily: PsConfig.ps_default_font_family),
        displaySmall: TextStyle(
            color: PsColors.primaryDarkWhite,
            fontFamily: PsConfig.ps_default_font_family),
        headlineMedium: TextStyle(
          color: PsColors.primaryDarkWhite,
          fontFamily: PsConfig.ps_default_font_family,
        ),
        headlineSmall: TextStyle(
            color: PsColors.primaryDarkWhite,
            fontFamily: PsConfig.ps_default_font_family,
            fontWeight: FontWeight.bold),
        titleLarge: TextStyle(
            color: PsColors.primaryDarkWhite,
            fontFamily: PsConfig.ps_default_font_family),
        titleMedium: TextStyle(
            color: PsColors.primaryDarkWhite,
            fontFamily: PsConfig.ps_default_font_family,
            fontWeight: FontWeight.bold),
        titleSmall: TextStyle(
            color: PsColors.primaryDarkWhite,
            fontFamily: PsConfig.ps_default_font_family,
            fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(
          color: PsColors.primaryDarkWhite,
          fontFamily: PsConfig.ps_default_font_family,
        ),
        bodyMedium: TextStyle(
            color: PsColors.primaryDarkWhite,
            fontFamily: PsConfig.ps_default_font_family,
            fontWeight: FontWeight.bold),
        labelLarge: TextStyle(
            color: PsColors.primaryDarkWhite,
            fontFamily: PsConfig.ps_default_font_family),
        bodySmall: TextStyle(
            color: PsColors.primaryDarkGrey,
            fontFamily: PsConfig.ps_default_font_family),
        labelSmall: TextStyle(
            color: PsColors.primaryDarkWhite,
            fontFamily: PsConfig.ps_default_font_family),
      ),
      iconTheme: IconThemeData(color: PsColors.primaryDarkWhite),
      appBarTheme:
          AppBarTheme(color: PsColors.baseColor), //coreBackgroundColor),
    );
  } else {
    PsColors.loadColor2(true);
    // White Theme
    return baseTheme.copyWith(
        primaryColor: PsColors.primary500,
        primaryColorDark: PsColors.primary900,
        primaryColorLight: PsColors.primary50,
        textTheme: TextTheme(
          displayLarge: TextStyle(
              color: PsColors.secondary500,
              fontFamily: PsConfig.ps_default_font_family),
          displayMedium: TextStyle(
              color: PsColors.secondary500,
              fontFamily: PsConfig.ps_default_font_family),
          displaySmall: TextStyle(
              color: PsColors.secondary500,
              fontFamily: PsConfig.ps_default_font_family),
          headlineMedium: TextStyle(
            color: PsColors.secondary500,
            fontFamily: PsConfig.ps_default_font_family,
          ),
          headlineSmall: TextStyle(
              color: PsColors.secondary500,
              fontFamily: PsConfig.ps_default_font_family,
              fontWeight: FontWeight.bold),
          titleLarge: TextStyle(
              color: PsColors.secondary500,
              fontFamily: PsConfig.ps_default_font_family),
          titleMedium: TextStyle(
              color: PsColors.secondary500,
              fontFamily: PsConfig.ps_default_font_family,
              fontWeight: FontWeight.bold),
          titleSmall: TextStyle(
              color: PsColors.secondary500,
              fontFamily: PsConfig.ps_default_font_family,
              fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(
            color: PsColors.secondary500,
            fontFamily: PsConfig.ps_default_font_family,
          ),
          bodyMedium: TextStyle(
              color: PsColors.secondary500,
              fontFamily: PsConfig.ps_default_font_family,
              fontWeight: FontWeight.bold),
          labelLarge: TextStyle(
              color: PsColors.secondary500,
              fontFamily: PsConfig.ps_default_font_family),
          bodySmall: TextStyle(
              color: PsColors.secondary400,
              fontFamily: PsConfig.ps_default_font_family),
          labelSmall: TextStyle(
              color: PsColors.secondary500,
              fontFamily: PsConfig.ps_default_font_family),
        ),
        iconTheme: IconThemeData(color: PsColors.secondary500),
        appBarTheme: AppBarTheme(
            color: PsColors.primaryDarkWhite)); //coreBackgroundColor));
  }
}
