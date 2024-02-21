

import 'package:flutterbuyandsell/db/common/ps_shared_preferences.dart';
import 'package:flutterbuyandsell/viewobject/ps_mobile_config_setting.dart';

class PsRepository {
  Future<dynamic> loadValueHolder() async {
    PsSharedPreferences.instance.loadValueHolder();
  }

  Future<dynamic> replaceLoginUserId(String loginUserId) async {
    await PsSharedPreferences.instance.replaceLoginUserId(
      loginUserId,
    );
  }

  Future<dynamic> replaceLoginUserName(String loginUserName) async {
    await PsSharedPreferences.instance.replaceLoginUserName(
      loginUserName,
    );
  }

  Future<dynamic> replaceNotiToken(String notiToken) async {
    await PsSharedPreferences.instance.replaceNotiToken(
      notiToken,
    );
  }

  Future<dynamic> replaceIsSubLocation(String isSubLocation) async {
    await PsSharedPreferences.instance.replaceIsSubLocation(
      isSubLocation,
    );
  }

  Future<dynamic> replaceMaxImageCount(int isSubLocation) async {
    await PsSharedPreferences.instance.replaceMaxImageCount(
      isSubLocation,
    );
  }

  Future<dynamic> replaceMobileConfigSetting(PSMobileConfigSetting psMobileConfigSetting) async {
    await PsSharedPreferences.instance.replaceMobileConfigSetting(
      psMobileConfigSetting
    );
  }

  Future<dynamic> replaceisBlockedFeatueDisabled(String isBlockedFeatueDisabled) async {
    await PsSharedPreferences.instance.replaceisBlockedFeatueDisabled(
      isBlockedFeatueDisabled,
    );
  }

  Future<dynamic> replaceIsPaidApp(String isPaidApp) async {
    await PsSharedPreferences.instance.replaceIsPaindApp(
      isPaidApp,
    );
  }
    Future<dynamic> replaceIsSubCatSubscribe(String isSubCatSubscribe) async {
    await PsSharedPreferences.instance.replaceIsSubCatSubscribe(
      isSubCatSubscribe,
    );
  }

  Future<dynamic> replaceDefaultCurrency(
      String defaultCurrencyId, String defaultCurrency) async {
    await PsSharedPreferences.instance
        .replaceDefaultCurrency(defaultCurrencyId, defaultCurrency);
  }

  Future<dynamic> replaceItemUploadConfig( String address, String brand, String latitude, String longitude,
    String businessMode, String subCatId, String typeId, String priceTypeId,
    String conditionOfItemId, String dealOptionId, String dealOptionRemark, String highlightInfo,
    String video, String videoIcon,String discountRateByPercentage) async {
      await PsSharedPreferences.instance
          .replaceItemUploadConfig(
            address, brand, latitude, longitude, businessMode, subCatId, typeId, priceTypeId,
            conditionOfItemId, dealOptionId, dealOptionRemark, highlightInfo, video, videoIcon,discountRateByPercentage);
  }

  Future<dynamic> replaceNotiSetting(bool notiSetting) async {
    await PsSharedPreferences.instance.replaceNotiSetting(
      notiSetting,
    );
  }

  Future<dynamic> replaceItemLocationTownshipData(
      String locationTownshipId,
      String locationCityId,
      String locationTownshipName,
      String locationTownshipLat,
      String locationTownshipLng) async {
    await PsSharedPreferences.instance.replaceItemLocationTownshipData(
        locationTownshipId,
        locationCityId,
        locationTownshipName,
        locationTownshipLat,
        locationTownshipLng);
  }

  Future<dynamic> replaceCustomCameraSetting(bool cameraSetting) async {
    await PsSharedPreferences.instance.replaceCustomCameraSetting(
      cameraSetting,
    );
  }

  Future<dynamic> replaceIsToShowIntroSlider(bool doNotShowAgain) async {
    await PsSharedPreferences.instance.replaceIsToShowIntroSlider(
      doNotShowAgain,
    );
  }

  Future<dynamic> replaceDate(String startDate, String endDate) async {
    await PsSharedPreferences.instance.replaceDate(startDate, endDate);
  }

  Future<dynamic> replacePackageIAPKeys(String packageAndroidKeyList, String packageIOSKeyList) async {
    await PsSharedPreferences.instance.replacePackageIAPKeys(packageAndroidKeyList, packageIOSKeyList);
  }

  Future<dynamic> replaceVerifyUserData(
      String userIdToVerify,
      String userNameToVerify,
      String userEmailToVerify,
      String userPasswordToVerify) async {
    await PsSharedPreferences.instance.replaceVerifyUserData(userIdToVerify,
        userNameToVerify, userEmailToVerify, userPasswordToVerify);
  }

  Future<dynamic> replaceItemLocationData(String locationId,
      String locationName, String locationLat, String locationLng) async {
    await PsSharedPreferences.instance.replaceItemLocationData(
        locationId, locationName, locationLat, locationLng);
  }

  Future<dynamic> replaceVersionForceUpdateData(bool appInfoForceUpdate) async {
    await PsSharedPreferences.instance.replaceVersionForceUpdateData(
      appInfoForceUpdate,
    );
  }

  Future<dynamic> replaceAppInfoData(
      String appInfoVersionNo,
      bool appInfoForceUpdate,
      String appInfoForceUpdateTitle,
      String appInfoForceUpdateMsg) async {
    await PsSharedPreferences.instance.replaceAppInfoData(appInfoVersionNo,
        appInfoForceUpdate, appInfoForceUpdateTitle, appInfoForceUpdateMsg);
  }

  Future<dynamic> replaceShopInfoValueHolderData(
    String overAllTaxLabel,
    String overAllTaxValue,
    String shippingTaxLabel,
    String shippingTaxValue,
    String shippingId,
    String shopId,
    String messenger,
    String whatsApp,
    String phone,
  ) async {
    await PsSharedPreferences.instance.replaceShopInfoValueHolderData(
        overAllTaxLabel,
        overAllTaxValue,
        shippingTaxLabel,
        shippingTaxValue,
        shippingId,
        shopId,
        messenger,
        whatsApp,
        phone);
  }

  Future<dynamic> replaceCheckoutEnable(
      String paypalEnabled,
      String stripeEnabled,
      String codEnabled,
      String bankEnabled,
      String standardShippingEnable,
      String zoneShippingEnable,
      String noShippingEnable) async {
    await PsSharedPreferences.instance.replaceCheckoutEnable(
        paypalEnabled,
        stripeEnabled,
        codEnabled,
        bankEnabled,
        standardShippingEnable,
        zoneShippingEnable,
        noShippingEnable);
  }

  Future<dynamic> replacePublishKey(String pubKey) async {
    await PsSharedPreferences.instance.replacePublishKey(pubKey);
  }

    Future<dynamic> replaceAdType(String adType) async {
    await PsSharedPreferences.instance.replaceAdType(adType);
  }


  Future<dynamic> replacePromoCellNo(String promoCellNo) async {
    await PsSharedPreferences.instance.replacePromoCellNo(promoCellNo);
  }


  Future<dynamic> replaceDetailOpenCount(int count) async {
    await PsSharedPreferences.instance.replaceDetailOpenCount(count);
  }

      Future<dynamic> replaceIsUserAlreadyChoose(bool isUserAlreadyChoose) async {
    await PsSharedPreferences.instance.replaceIsUserAlreadyChoose(
      isUserAlreadyChoose,
    );
  }
}
