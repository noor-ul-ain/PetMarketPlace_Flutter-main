

import 'dart:async';

import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/ps_mobile_config_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PsSharedPreferences {
  PsSharedPreferences._() {
    Utils.psPrint('init PsSharePerference $hashCode');
    futureShared = SharedPreferences.getInstance();
    futureShared.then((SharedPreferences shared) {
      this.shared = shared;
      //loadUserId('Admin');
      loadValueHolder();
    });
  }

  late Future<SharedPreferences> futureShared;
  late SharedPreferences shared;

// Singleton instance
  static final PsSharedPreferences _singleton = PsSharedPreferences._();

  // Singleton accessor
  static PsSharedPreferences get instance => _singleton;

  final StreamController<PsValueHolder> _valueController =
      StreamController<PsValueHolder>();
  Stream<PsValueHolder> get psValueHolder => _valueController.stream;

  void loadValueHolder() {
    final String? _loginUserId = shared.getString(PsConst.VALUE_HOLDER__USER_ID);
      // replaceItemLocationData('', 'All', PsConst.INVALID_LAT_LNG, PsConst.INVALID_LAT_LNG);
      // replaceItemLocationTownshipData('', '', 'All', PsConst.INVALID_LAT_LNG, PsConst.INVALID_LAT_LNG);
    // shared.clear();
    final String? _loginUserName =
        shared.getString(PsConst.VALUE_HOLDER__USER_NAME);
    final String? _userIdToVerify =
        shared.getString(PsConst.VALUE_HOLDER__USER_ID_TO_VERIFY);
    final String? _userNameToVerify =
        shared.getString(PsConst.VALUE_HOLDER__USER_NAME_TO_VERIFY);
    final String? _userEmailToVerify =
        shared.getString(PsConst.VALUE_HOLDER__USER_EMAIL_TO_VERIFY);
    final String? _userPasswordToVerify =
        shared.getString(PsConst.VALUE_HOLDER__USER_PASSWORD_TO_VERIFY);
    final String? _notiToken =
        shared.getString(PsConst.VALUE_HOLDER__NOTI_TOKEN);
    final String _isSubLocation =
        shared.getString(PsConst.VALUE_HOLDER__IS_SUB_LOCATION) ?? '';
    final int _maxImageCount = 
        shared.getInt(PsConst.VALUE_HOLDER__MAX_IMAGE_COUNT) ?? 1;    
    final String _defaultCurrency =
        shared.getString(PsConst.VALUE_HOLDER__DEFAULT_CURRENCY) ?? '';
    final String _defaultCurrencyId =
        shared.getString(PsConst.VALUE_HOLDER__DEFAULT_CURRENCY_ID) ?? '';
    final bool? _notiSetting =
        shared.getBool(PsConst.VALUE_HOLDER__NOTI_SETTING);
    final bool _cameraSetting =
        shared.getBool(PsConst.VALUE_HOLDER__CAMERA_SETTING) ?? false;
    final bool _isToShowIntroSlider =
        shared.getBool(PsConst.VALUE_HOLDER__SHOW_INTRO_SLIDER) ?? true;
    final String? _overAllTaxLabel =
        shared.getString(PsConst.VALUE_HOLDER__OVERALL_TAX_LABEL);
    final String? _overAllTaxValue =
        shared.getString(PsConst.VALUE_HOLDER__OVERALL_TAX_VALUE);
    final String? _shippingTaxLabel =
        shared.getString(PsConst.VALUE_HOLDER__SHIPPING_TAX_LABEL);
    final String? _shippingTaxValue =
        shared.getString(PsConst.VALUE_HOLDER__SHIPPING_TAX_VALUE);
    final String? _shippingId =
        shared.getString(PsConst.VALUE_HOLDER__SHIPPING_ID);
    final String? _shopId = shared.getString(PsConst.VALUE_HOLDER__SHOP_ID);
    final String? _messenger = shared.getString(PsConst.VALUE_HOLDER__MESSENGER);
    final String? _whatsApp = shared.getString(PsConst.VALUE_HOLDER__WHATSAPP);
    final String? _phone = shared.getString(PsConst.VALUE_HOLDER__PHONE);
    final String? _appInfoVersionNo =
        shared.getString(PsConst.APPINFO_PREF_VERSION_NO);
    final bool? _appInfoForceUpdate =
        shared.getBool(PsConst.APPINFO_PREF_FORCE_UPDATE);
    final String? _appInfoForceUpdateTitle =
        shared.getString(PsConst.APPINFO_FORCE_UPDATE_TITLE);
    final String? _appInfoForceUpdateMsg =
        shared.getString(PsConst.APPINFO_FORCE_UPDATE_MSG);
    final String? _startDate =
        shared.getString(PsConst.VALUE_HOLDER__START_DATE);
    final String? _endDate = shared.getString(PsConst.VALUE_HOLDER__END_DATE);
    final String? _packageAndroidKeyList = shared.getString(PsConst.VALUE_HOLDER__PACKAGE_ANDROID_IAP);
    final String? _packageIOSKeyList = shared.getString(PsConst.VALUE_HOLDER__PACKAGE_IOS_IAP);     

    final String? _paypalEnabled =
        shared.getString(PsConst.VALUE_HOLDER__PAYPAL_ENABLED);
    final String? _stripeEnabled =
        shared.getString(PsConst.VALUE_HOLDER__STRIPE_ENABLED);
    final String? _codEnabled =
        shared.getString(PsConst.VALUE_HOLDER__COD_ENABLED);
    final String? _bankEnabled =
        shared.getString(PsConst.VALUE_HOLDER__BANK_TRANSFER_ENABLE);
    final String? _publishKey =
        shared.getString(PsConst.VALUE_HOLDER__PUBLISH_KEY);

    final String? _standardShippingEnable =
        shared.getString(PsConst.VALUE_HOLDER__STANDART_SHIPPING_ENABLE);
    final String? _zoneShippingEnable =
        shared.getString(PsConst.VALUE_HOLDER__ZONE_SHIPPING_ENABLE);
    final String? _noShippingEnable =
        shared.getString(PsConst.VALUE_HOLDER__NO_SHIPPING_ENABLE);
    final String _locationTownshipId =
        shared.getString(PsConst.VALUE_HOLDER__LOCATION_TOWNSHIP_ID) ?? '';
    final String _locationTownshipName =
        shared.getString(PsConst.VALUE_HOLDER__LOCATION_TOWNSHIP_NAME) ?? 'All';
    final String _locationTownshipLat =
        shared.getString(PsConst.VALUE_HOLDER__LOCATION_TOWNSHIP_LAT) ?? '0';
    final String _locationTownshipLng =
        shared.getString(PsConst.VALUE_HOLDER__LOCATION_TOWNSHIP_LNG) ?? '0';
    final String? _locationId =
        shared.getString(PsConst.VALUE_HOLDER__LOCATION_ID)??'';
    final String? _locationName =
        shared.getString(PsConst.VALUE_HOLDER__LOCATION_NAME)??'All';
    final String? _locationLat =
        shared.getString(PsConst.VALUE_HOLDER__LOCATION_LAT)??'0.000000';
    final String? _locationLng =
        shared.getString(PsConst.VALUE_HOLDER__LOCATION_LNG)??'0.000000';
    final int? _detailOpenCount =
        shared.getInt(PsConst.VALUE_HOLDER__DETAIL_OPEN_COUNTER);

    // final String _title =
    //     shared.getString(PsConst.VALUE_HOLDER__TITLE) ?? '';
    // final String _desc =
    //     shared.getString(PsConst.VALUE_HOLDER__DESC) ?? ''; 
    // final String _price =
    //     shared.getString(PsConst.VALUE_HOLDER__PRICE) ?? '';
    // final String _currency =
    //     shared.getString(PsConst.VALUE_HOLDER__CURRENCY) ?? '';
    // final String _itemLocation =
    //     shared.getString(PsConst.VALUE_HOLDER__LOCATION) ?? ''; 
    // final String _catId =
    //     shared.getString(PsConst.VALUE_HOLDER__CAT_ID) ?? '';
    // final String _image =
    //     shared.getString(PsConst.VALUE_HOLDER__IMAGE) ?? '';
    final String _address =
        shared.getString(PsConst.VALUE_HOLDER__ADDRESS) ?? '';
    final String _brand =
        shared.getString(PsConst.VALUE_HOLDER__BRAND) ?? '';
    final String _lat =
        shared.getString(PsConst.VALUE_HOLDER__LAT) ?? '';
    final String _lng =
        shared.getString(PsConst.VALUE_HOLDER__LNG) ?? '';
    final String _businesMode =
        shared.getString(PsConst.VALUE_HOLDER__BUSINESS_MODE) ?? '';
    // final String _itemLocationTownship =
    //     shared.getString(PsConst.VALUE_HOLDER__LOCATION_TOWNSHIP) ?? '';
    final String _subCatId =
        shared.getString(PsConst.VALUE_HOLDER__SUB_CAT) ?? '';
    final String _type =
        shared.getString(PsConst.VALUE_HOLDER__TYPE) ?? '';
    final String _priceType =
        shared.getString(PsConst.VALUE_HOLDER__PRICE_TYPE) ?? ''; 
    final String _conditionOfItem =
        shared.getString(PsConst.VALUE_HOLDER__CONDITION_OF_ITEM) ?? '';
    final String _dealOption =
        shared.getString(PsConst.VALUE_HOLDER__DEAL_OPTION) ?? '';
    final String _dealOptionRemark =
        shared.getString(PsConst.VALUE_HOLDER__DEAL_OPTION_REMARK) ?? '';
    final String _highlightInfo =
        shared.getString(PsConst.VALUE_HOLDER__HIGHLIGHT_INFO) ?? '';
    final String _video =
        shared.getString(PsConst.VALUE_HOLDER__VIDEO) ?? '';
    final String _videoIcon =
        shared.getString(PsConst.VALUE_HOLDER__VIDEO_ICON) ?? '';        

    final String _isBlockedFeatureDisabled =
        shared.getString(PsConst.VALUE_HOLDER__BLOCK_FEATURE) ?? '';      

    final String _isPaidApp =
        shared.getString(PsConst.VALUE_HOLDER__PAID_APP) ?? '';   

    final String _isSubCatSubscribe =
        shared.getString(PsConst.VALUE_HOLDER__ISSUBCAT_SUBSCRIBE) ?? '';   

   final String _discountRateByPercentage =
        shared.getString(PsConst.VALUE_HOLDER__DISCOUNT_RATEBY_PERCENTAGE) ?? '';  

    ///Mobile Config    
    final String _googlePlayStoreUrl = shared.getString(PsConst.GOOGLEPLAYSTOREURL) ?? '';
    final String _appleAppStoreUrl = shared.getString(PsConst.APPLEAPPSTOREURL) ?? '';
    final String _priceFormat = shared.getString(PsConst.PRICEFORMAT) ?? ',##0.00';
    final String _dateFormat = shared.getString(PsConst.DATEFORMAT) ?? 'dd MMM yyyy';
    final String _iosAppStoreId = shared.getString(PsConst.IOSAPPSTOREID) ?? '';
    final bool _isUseThumnailAsPlaceHolder = shared.getBool(PsConst.ISUSETHUMBNAILASPLACEHOLDER) ?? false;
    final bool _isShowTokenId = shared.getBool(PsConst.ISSHOWTOKENID) ?? false;
    final bool _isShowSubCategory = shared.getBool(PsConst.ISSHOWSUBCATEGORY) ?? false;
    final String _fbKey = shared.getString(PsConst.FBKEY) ?? '';
    final bool _isShowAdmob = shared.getBool(PsConst.ISSHOWADMOB) ?? false;
    final int _defaultLoadingLimit = shared.getInt(PsConst.DEFATULTLOADINGLIMIT) ?? 30;
    final int _categoryLoadingLimit = shared.getInt(PsConst.CATEGORYLOADINGLIMIT) ?? 30;
    final int _recentLodingLimit = shared.getInt(PsConst.RECENTLOADINGLIMIT) ?? 30;
    final int _popularLoadingLimit = shared.getInt(PsConst.POPULARLOADINGLIMIT) ?? 30;
    final int _discountLoadingLimit = shared.getInt(PsConst.DISCOUNTLOADINGLIMIT) ?? 30;
    final int _featuredLoadingLimit = shared.getInt(PsConst.FEATUREDLOADINGLIMIT) ?? 30;
    final int _blockSliderLoadingLimit = shared.getInt(PsConst.BLOCKSLIDERLOADINGLIMIT) ?? 30;
    final int _followerLoadingLimit = shared.getInt(PsConst.FOLLOWERLOADINGLIMIT) ?? 30;
    final int _blockItemLoadingLimit = shared.getInt(PsConst.BLOCKITEMLOADINGLIMIT) ?? 30;
    final bool _showFacebookLogin = shared.getBool(PsConst.SHOWFACEBOOKLOGIN) ?? false;
    final bool _showGoogleLogin = shared.getBool(PsConst.SHOWGOOGLELOGIN) ?? false;
    final bool _showPhoneLogin = shared.getBool(PsConst.SHOWPHONELOGIN) ?? false;
    final bool _isRazorSupportMultiCurrency = shared.getBool(PsConst.ISRAZORSUPPORTMULTIICURRENCY) ?? false;
    final String _defaultRazorCurrency = shared.getString(PsConst.DEFAULTRAZORCURRENCY) ?? 'INR';
    final int _itemDetailViewCountforAds = shared.getInt(PsConst.ITEMDETAILVIEWCOUNTFORADS) ?? 5;
    final bool _isShowAdsInItemDetail = shared.getBool(PsConst.ISSHOWADSINITEMDETAIL) ?? false;
    final bool _isShowAdmobInsideList = shared.getBool(PsConst.ISHOWADMOBINSIDELIST) ?? false;
    final double _bluemarkSize = shared.getDouble(PsConst.BLUEMARKSIZE) ?? 15.0;
    final String _mile = shared.getString(PsConst.MILE) ?? '8';
    final String _videoDuration = shared.getString(PsConst.VIDEODURATION) ?? '60000';
    final bool _isUseGoogleMap = shared.getBool(PsConst.ISUSEGOOGLEMAP) ?? false; 
    final int _profileImageSize = shared.getInt(PsConst.PROFILEIMAGESIZE) ?? 512;
    final int _uploadImageSize = shared.getInt(PsConst.UPLOADIMAGESIZE) ?? 1024;
    final int _chatImageSize = shared.getInt(PsConst.CHATIMAGESIZE) ?? 650;
    final String _promoteFirstChoiceDay = shared.getString(PsConst.PROMOTEFIRSTCHOICEDAY) ?? '7';
    final String _promoteSecondChoiceDay = shared.getString(PsConst.PROMOTESECONDCHOICEDAY) ?? '14';
    final String _promoteThirdChoiceDay = shared.getString(PsConst.PROMOTETHIRDCHOICEDAY) ?? '30';
    final String _promoteFourthChoiceDay = shared.getString(PsConst.PROMOTEFOURTHCHOICEDAY) ?? '60';
    final bool _nofilterWithLocationOnMap = shared.getBool(PsConst.NOFILTERWITHLOCATIONONMAP) ?? false;
    final bool _isShowOwnerInfo = shared.getBool(PsConst.ISSHOWOWNERINFO) ?? false;
    final bool _isForceLogin = shared.getBool(PsConst.ISFORCELOGIN) ?? false;
    final bool _isLanguageConfig = shared.getBool(PsConst.ISLANGUAGECONFIG) ?? false;
    final String _defaultLanguageCode = shared.getString(PsConst.DEFAULTLANGUAGE) ?? 'en';
    final bool? _isUserAlradyChoose = shared.getBool(PsConst.VALUE_HOLDER__USER_ALREADY_CHOOSE);

    final String? _adType = shared.getString(PsConst.VALUE_HOLDER__AD_TYPE);
    final String? _promoCellNo = shared.getString(PsConst.VALUE_HOLDER__PROMO_CELL_NO);

    final PsValueHolder _valueHolder = PsValueHolder(
        loginUserId: _loginUserId,
        loginUserName: _loginUserName,
        locationId: _locationId,
        locactionName: _locationName,
        locationLat: _locationLat,
        locationLng: _locationLng,
        locationTownshipId: _locationTownshipId,
        locationTownshipName: _locationTownshipName,
        locationTownshipLat: _locationTownshipLat,
        locationTownshipLng: _locationTownshipLng,
        userIdToVerify: _userIdToVerify,
        userNameToVerify: _userNameToVerify,
        userEmailToVerify: _userEmailToVerify,
        userPasswordToVerify: _userPasswordToVerify,
        deviceToken: _notiToken,
        isSubLocation: _isSubLocation,
        maxImageCount: _maxImageCount,
        defaultCurrency: _defaultCurrency,
        defaultCurrencyId: _defaultCurrencyId,
        notiSetting: _notiSetting,
        isCustomCamera: _cameraSetting,
        isToShowIntroSlider: _isToShowIntroSlider,
        overAllTaxLabel: _overAllTaxLabel,
        overAllTaxValue: _overAllTaxValue,
        shippingTaxLabel: _shippingTaxLabel,
        shippingTaxValue: _shippingTaxValue,
        shopId: _shopId,
        messenger: _messenger,
        whatsApp: _whatsApp,
        phone: _phone,
        appInfoVersionNo: _appInfoVersionNo,
        appInfoForceUpdate: _appInfoForceUpdate,
        appInfoForceUpdateTitle: _appInfoForceUpdateTitle,
        appInfoForceUpdateMsg: _appInfoForceUpdateMsg,
        startDate: _startDate,
        endDate: _endDate,
        paypalEnabled: _paypalEnabled,
        stripeEnabled: _stripeEnabled,
        codEnabled: _codEnabled,
        bankEnabled: _bankEnabled,
        publishKey: _publishKey,
        shippingId: _shippingId,
        standardShippingEnable: _standardShippingEnable,
        zoneShippingEnable: _zoneShippingEnable,
        noShippingEnable: _noShippingEnable,
        detailOpenCount: _detailOpenCount,
        address: _address,
        brand: _brand, 
        businessMode: _businesMode, 
        conditionOfItemId: _conditionOfItem, 
        typeId: _type, 
        subCatId: _subCatId, 
        priceTypeId: _priceType, 
        dealOptionId: _dealOption, 
        dealOptionRemark: _dealOptionRemark, 
        highlightInfo: _highlightInfo, 
        latitude: _lat, 
        longitude: _lng,
        video: _video,
        videoIcon: _videoIcon,
        blockedFeatureDisabled: _isBlockedFeatureDisabled,
        isPaidApp: _isPaidApp,
        isSubCatSubscribe: _isSubCatSubscribe,
        googlePlayStoreUrl: _googlePlayStoreUrl,
        appleAppStoreUrl: _appleAppStoreUrl,
        priceFormat: _priceFormat,
        dateFormat: _dateFormat,
        iosAppStoreId: _iosAppStoreId,
        isUseThumbnailAsPlaceHolder: _isUseThumnailAsPlaceHolder,
        isShowTokenId: _isShowTokenId,
        isShowSubcategory: _isShowSubCategory,
        fbKey: _fbKey,
        isShowAdmob: _isShowAdmob,
        defaultLoadingLimit: _defaultLoadingLimit,
        categoryLoadingLimit: _categoryLoadingLimit,
        recentItemLoadingLimit: _recentLodingLimit,
        populartItemLoadingLimit: _popularLoadingLimit,
        discountItemLoadingLimit: _discountLoadingLimit,
        featuredItemLoadingLimit: _featuredLoadingLimit,
        blockSliderLoadingLimit: _blockSliderLoadingLimit,
        followerItemLoadingLimit: _followerLoadingLimit,
        blockItemLoadingLimit: _blockItemLoadingLimit,
        showFacebookLogin: _showFacebookLogin,
        showGoogleLogin: _showGoogleLogin,
        showPhoneLogin: _showPhoneLogin,
        isRazorSupportMultiCurrency: _isRazorSupportMultiCurrency,
        defaultRazorCurrency: _defaultRazorCurrency,
        itemDetailViewCountForAds: _itemDetailViewCountforAds,
        isShowAdsInItemDetail: _isShowAdsInItemDetail,
        isShowAdmobInsideList: _isShowAdmobInsideList,
        bluemarkSize: _bluemarkSize,
        mile: _mile,
        videoDuration: _videoDuration,
        isUseGoogleMap: _isUseGoogleMap,
        profileImageSize: _profileImageSize,
        uploadImageSize: _uploadImageSize,
        chatImageSize: _chatImageSize,
        promoteFirstChoiceDay: _promoteFirstChoiceDay,
        promoteSecondChoiceDay: _promoteSecondChoiceDay,
        promoteThirdChoiceDay: _promoteThirdChoiceDay,
        promoteFourthChoiceDay: _promoteFourthChoiceDay,
        noFilterWithLocationOnMap: _nofilterWithLocationOnMap,
        isShowOwnerInfo: _isShowOwnerInfo,
        isForceLogin: _isForceLogin,
        isLanguageConfig: _isLanguageConfig,
        defaultLanguageCode: _defaultLanguageCode,
        isUserAlradyChoose: _isUserAlradyChoose,
        adType: _adType,
        promoCellNo: _promoCellNo,
        discountRateByPercentage: _discountRateByPercentage,
        packageAndroidKeyList: _packageAndroidKeyList,
        packageIOSKeyList: _packageIOSKeyList,
        );

    _valueController.add(_valueHolder);
  }

  Future<dynamic> replaceLoginUserId(String loginUserId) async {
    await shared.setString(PsConst.VALUE_HOLDER__USER_ID, loginUserId);

    loadValueHolder();
  }

  Future<dynamic> replaceAddedUserId(String addedUserId) async {
    await shared.setString(PsConst.VALUE_HOLDER__ADDED_USER_ID, addedUserId);

    loadValueHolder();
  }

  Future<dynamic> replaceLoginUserName(String loginUserName) async {
    await shared.setString(PsConst.VALUE_HOLDER__USER_NAME, loginUserName);

    loadValueHolder();
  }

  Future<dynamic> replaceNotiToken(String notiToken) async {
    await shared.setString(PsConst.VALUE_HOLDER__NOTI_TOKEN, notiToken);

    loadValueHolder();
  }

  Future<dynamic> replaceIsSubLocation(String isSubLocation) async {
    await shared.setString(
        PsConst.VALUE_HOLDER__IS_SUB_LOCATION, isSubLocation);

    loadValueHolder();
  }

  Future<dynamic> replaceMaxImageCount(int maxImageCount) async {
    await shared.setInt(
        PsConst.VALUE_HOLDER__MAX_IMAGE_COUNT, maxImageCount);

    loadValueHolder();
  }

  Future<dynamic> replaceMobileConfigSetting(PSMobileConfigSetting psMobileConfigSetting) async {
    await shared.setString(PsConst.GOOGLEPLAYSTOREURL, psMobileConfigSetting.googlePlayStoreUrl ?? '');
    await shared.setString(PsConst.APPLEAPPSTOREURL, psMobileConfigSetting.appleAppStoreUrl ?? '');
    await shared.setString(PsConst.PRICEFORMAT, psMobileConfigSetting.priceFormat ?? ',##0.00');
    await shared.setString(PsConst.DATEFORMAT, psMobileConfigSetting.dateFormat ?? 'dd MMM yyyy');
    await shared.setString(PsConst.IOSAPPSTOREID, psMobileConfigSetting.iosAppStoreId ?? '');
    await shared.setBool(PsConst.ISUSETHUMBNAILASPLACEHOLDER, psMobileConfigSetting.isUseThumbnailAsPlaceHolder == '1');
    await shared.setBool(PsConst.ISSHOWTOKENID, psMobileConfigSetting.isShowTokenId == '1');
    await shared.setBool(PsConst.ISSHOWSUBCATEGORY, psMobileConfigSetting.isShowSubcategory == '1');
    await shared.setString(PsConst.FBKEY, psMobileConfigSetting.fbKey ?? '');
    await shared.setBool(PsConst.ISSHOWADMOB, psMobileConfigSetting.isShowAdmob == '1');
    await shared.setInt(PsConst.DEFATULTLOADINGLIMIT, int.parse(psMobileConfigSetting.defaultLoadingLimit ?? '30'));
    await shared.setInt(PsConst.CATEGORYLOADINGLIMIT, int.parse(psMobileConfigSetting.categoryLoadingLimit ?? '30'));
    await shared.setInt(PsConst.RECENTLOADINGLIMIT, int.parse(psMobileConfigSetting.recentItemLoadingLimit ?? '30'));
    await shared.setInt(PsConst.POPULARLOADINGLIMIT, int.parse(psMobileConfigSetting.populartItemLoadingLimit ?? '30'));
    await shared.setInt(PsConst.DISCOUNTLOADINGLIMIT, int.parse(psMobileConfigSetting.discountItemLoadingLimit ?? '30'));
    await shared.setInt(PsConst.FEATUREDLOADINGLIMIT, int.parse(psMobileConfigSetting.featuredItemLoadingLimit ?? '30'));
    await shared.setInt(PsConst.BLOCKSLIDERLOADINGLIMIT, int.parse(psMobileConfigSetting.blockSliderLoadingLimit ?? '30'));
    await shared.setInt(PsConst.FOLLOWERLOADINGLIMIT, int.parse(psMobileConfigSetting.followerItemLoadingLimit ?? '30'));
    await shared.setInt(PsConst.BLOCKITEMLOADINGLIMIT, int.parse(psMobileConfigSetting.blockItemLoadingLimit ?? '30'));
    await shared.setBool(PsConst.SHOWFACEBOOKLOGIN, psMobileConfigSetting.showFacebookLogin == '1');
    await shared.setBool(PsConst.SHOWGOOGLELOGIN, psMobileConfigSetting.showGoogleLogin == '1');
    await shared.setBool(PsConst.SHOWPHONELOGIN, psMobileConfigSetting.showPhoneLogin == '1');
    await shared.setBool(PsConst.ISRAZORSUPPORTMULTIICURRENCY, psMobileConfigSetting.isRazorSupportMultiCurrency == '1');
    await shared.setString(PsConst.DEFAULTRAZORCURRENCY, psMobileConfigSetting.defaultRazorCurrency ?? 'INR');
    await shared.setInt(PsConst.ITEMDETAILVIEWCOUNTFORADS, int.parse(psMobileConfigSetting.itemDetailViewCountForAds ?? '5'));
    await shared.setBool(PsConst.ISSHOWADSINITEMDETAIL, psMobileConfigSetting.isShowAdsInItemDetail == '1');
    await shared.setBool(PsConst.ISHOWADMOBINSIDELIST, psMobileConfigSetting.isShowAdmobInsideList == '1');
    await shared.setDouble(PsConst.BLUEMARKSIZE, double.parse(psMobileConfigSetting.bluemarkSize ?? '15'));
    await shared.setString(PsConst.MILE, psMobileConfigSetting.mile ?? '8');
    await shared.setString(PsConst.VIDEODURATION, psMobileConfigSetting.videoDuration ?? '60000');
    await shared.setBool(PsConst.ISUSEGOOGLEMAP, psMobileConfigSetting.isUseGoogleMap == '1'); //*** */
    await shared.setInt(PsConst.PROFILEIMAGESIZE, int.parse(psMobileConfigSetting.profileImageSize ?? '512'));
    await shared.setInt(PsConst.UPLOADIMAGESIZE, int.parse(psMobileConfigSetting.uploadImageSize ?? '1024'));
    await shared.setInt(PsConst.CHATIMAGESIZE, int.parse(psMobileConfigSetting.chatImageSize ?? '650'));
    await shared.setString(PsConst.PROMOTEFIRSTCHOICEDAY, psMobileConfigSetting.promoteFirstChoiceDay ?? '7');
    await shared.setString(PsConst.PROMOTESECONDCHOICEDAY, psMobileConfigSetting.promoteSecondChoiceDay ?? '14');
    await shared.setString(PsConst.PROMOTETHIRDCHOICEDAY, psMobileConfigSetting.promoteThirdChoiceDay ?? '30');
    await shared.setString(PsConst.PROMOTEFOURTHCHOICEDAY, psMobileConfigSetting.promoteFourthChoiceDay ?? '60');
    await shared.setBool(PsConst.NOFILTERWITHLOCATIONONMAP, psMobileConfigSetting.noFilterWithLocationOnMap == '1');
    await shared.setBool(PsConst.ISSHOWOWNERINFO, psMobileConfigSetting.isShowOwnerInfo == '1');
    await shared.setBool(PsConst.ISFORCELOGIN, psMobileConfigSetting.isForceLogin == '1');
    await shared.setBool(PsConst.ISLANGUAGECONFIG, psMobileConfigSetting.isLanguageConfig == '1');
    await shared.setString(PsConst.DEFAULTLANGUAGE, psMobileConfigSetting.defaultLanguage!.languageCode ?? 'en');

    loadValueHolder();
  }


  Future<dynamic> replaceisBlockedFeatueDisabled(String isBlockedFeatueDisabled) async {
    await shared.setString(
        PsConst.VALUE_HOLDER__BLOCK_FEATURE, isBlockedFeatueDisabled);

    loadValueHolder();
  }

  Future<dynamic> replaceIsPaindApp(String isPaidApp) async {
    await shared.setString(
        PsConst.VALUE_HOLDER__PAID_APP, isPaidApp);

    loadValueHolder();
  }

    Future<dynamic> replaceIsSubCatSubscribe(String isSubCatSubscribe) async {
    await shared.setString(
        PsConst.VALUE_HOLDER__ISSUBCAT_SUBSCRIBE, isSubCatSubscribe);

    loadValueHolder();
  }

  Future<dynamic> replaceDefaultCurrency(
      String defaultCurrencyId, String defaultCurrency) async {
    await shared.setString(
        PsConst.VALUE_HOLDER__DEFAULT_CURRENCY_ID, defaultCurrencyId);
    await shared.setString(
        PsConst.VALUE_HOLDER__DEFAULT_CURRENCY, defaultCurrency);

    loadValueHolder();
  }

  Future<dynamic> replaceItemUploadConfig(String address, String brand, String latitude, String longitude,
    String businessMode, String subCatId, String typeId, String priceTypeId,
    String conditionOfItemId, String dealOptionId, String dealOptionRemark, String highlightInfo,
    String video, String videoIcon,String discountRateByPercentage)async {

    await shared.setString(PsConst.VALUE_HOLDER__ADDRESS, address); 
    await shared.setString(PsConst.VALUE_HOLDER__BRAND, brand); 
    await shared.setString(PsConst.VALUE_HOLDER__LAT, latitude); 
    await shared.setString(PsConst.VALUE_HOLDER__LNG, longitude); 
    await shared.setString(PsConst.VALUE_HOLDER__BUSINESS_MODE, businessMode); 
  //  await shared.setString(PsConst.VALUE_HOLDER__LOCATION_TOWNSHIP, locationTownshipId); 
    await shared.setString(PsConst.VALUE_HOLDER__SUB_CAT, subCatId); 
    await shared.setString(PsConst.VALUE_HOLDER__TYPE, typeId); 
    await shared.setString(PsConst.VALUE_HOLDER__PRICE_TYPE, priceTypeId); 
    await shared.setString(PsConst.VALUE_HOLDER__CONDITION_OF_ITEM, conditionOfItemId); 
    await shared.setString(PsConst.VALUE_HOLDER__DEAL_OPTION, dealOptionId); 
    await shared.setString(PsConst.VALUE_HOLDER__DEAL_OPTION_REMARK, dealOptionRemark); 
    await shared.setString(PsConst.VALUE_HOLDER__HIGHLIGHT_INFO, highlightInfo); 
    await shared.setString(PsConst.VALUE_HOLDER__VIDEO, video); 
    await shared.setString(PsConst.VALUE_HOLDER__VIDEO_ICON, videoIcon); 
    await shared.setString(PsConst.VALUE_HOLDER__DISCOUNT_RATEBY_PERCENTAGE,discountRateByPercentage);
    loadValueHolder();
  }

  String? getNotiMessage() {
    return shared.getString(PsConst.VALUE_HOLDER__NOTI_MESSAGE);
  }

  Future<dynamic> replaceNotiSetting(bool notiSetting) async {
    await shared.setBool(PsConst.VALUE_HOLDER__NOTI_SETTING, notiSetting);

    loadValueHolder();
  }

  Future<dynamic> replaceItemLocationTownshipData(
      String townshipId,
      String locationId,
      String locationTownshipName,
      String locationTownshipLat,
      String locationTownshipLng) async {
    await shared.setString(
        PsConst.VALUE_HOLDER__LOCATION_TOWNSHIP_ID, townshipId);
    await shared.setString(PsConst.VALUE_HOLDER__LOCATION_ID, locationId);
    await shared.setString(
        PsConst.VALUE_HOLDER__LOCATION_TOWNSHIP_NAME, locationTownshipName);
    await shared.setString(
        PsConst.VALUE_HOLDER__LOCATION_TOWNSHIP_LAT, locationTownshipLat);
    await shared.setString(
        PsConst.VALUE_HOLDER__LOCATION_TOWNSHIP_LNG, locationTownshipLng);

    loadValueHolder();
  }

  Future<dynamic> replaceCustomCameraSetting(bool cameraSetting) async {
    await shared.setBool(PsConst.VALUE_HOLDER__CAMERA_SETTING, cameraSetting);

    loadValueHolder();
  }

  Future<dynamic> replaceIsToShowIntroSlider(bool doNotShowAgain) async {
    await shared.setBool(
        PsConst.VALUE_HOLDER__SHOW_INTRO_SLIDER, doNotShowAgain);

    loadValueHolder();
  }

  Future<dynamic> replaceNotiMessage(String message) async {
    await shared.setString(PsConst.VALUE_HOLDER__NOTI_MESSAGE, message);
  }

  Future<dynamic> replaceDate(String startDate, String endDate) async {
    await shared.setString(PsConst.VALUE_HOLDER__START_DATE, startDate);
    await shared.setString(PsConst.VALUE_HOLDER__END_DATE, endDate);

    loadValueHolder();
  }

  Future<dynamic> replacePackageIAPKeys(String packageAndroidKeyList, String packageIOSKeyList) async {
    await shared.setString(PsConst.VALUE_HOLDER__PACKAGE_ANDROID_IAP, packageAndroidKeyList);
    await shared.setString(PsConst.VALUE_HOLDER__PACKAGE_IOS_IAP, packageIOSKeyList);

    loadValueHolder();
  }

  Future<dynamic> replaceVerifyUserData(
      String userIdToVerify,
      String userNameToVerify,
      String userEmailToVerify,
      String userPasswordToVerify) async {
    await shared.setString(
        PsConst.VALUE_HOLDER__USER_ID_TO_VERIFY, userIdToVerify);
    await shared.setString(
        PsConst.VALUE_HOLDER__USER_NAME_TO_VERIFY, userNameToVerify);
    await shared.setString(
        PsConst.VALUE_HOLDER__USER_EMAIL_TO_VERIFY, userEmailToVerify);
    await shared.setString(
        PsConst.VALUE_HOLDER__USER_PASSWORD_TO_VERIFY, userPasswordToVerify);

    loadValueHolder();
  }

  Future<dynamic> replaceItemLocationData(String locationId,
      String locationName, String locationLat, String locationLng) async {
    await shared.setString(PsConst.VALUE_HOLDER__LOCATION_ID, locationId);
    await shared.setString(PsConst.VALUE_HOLDER__LOCATION_NAME, locationName);
    await shared.setString(PsConst.VALUE_HOLDER__LOCATION_LAT, locationLat);
    await shared.setString(PsConst.VALUE_HOLDER__LOCATION_LNG, locationLng);

    loadValueHolder();
  }

  Future<dynamic> replaceVersionForceUpdateData(bool appInfoForceUpdate) async {
    await shared.setBool(PsConst.APPINFO_PREF_FORCE_UPDATE, appInfoForceUpdate);

    loadValueHolder();
  }

  Future<dynamic> replaceDetailOpenCount(int count) async {
    await shared.setInt(PsConst.VALUE_HOLDER__DETAIL_OPEN_COUNTER, count);

    loadValueHolder();
  }

  Future<dynamic> replaceAppInfoData(
      String appInfoVersionNo,
      bool appInfoForceUpdate,
      String appInfoForceUpdateTitle,
      String appInfoForceUpdateMsg) async {
    await shared.setString(PsConst.APPINFO_PREF_VERSION_NO, appInfoVersionNo);
    await shared.setBool(PsConst.APPINFO_PREF_FORCE_UPDATE, appInfoForceUpdate);
    await shared.setString(
        PsConst.APPINFO_FORCE_UPDATE_TITLE, appInfoForceUpdateTitle);
    await shared.setString(
        PsConst.APPINFO_FORCE_UPDATE_MSG, appInfoForceUpdateMsg);

    loadValueHolder();
  }

  Future<dynamic> replaceShopInfoValueHolderData(
    String overAllTaxLabel,
    String overAllTaxValue,
    String shippingTaxLabel,
    String shippingTaxValue,
    String shippingId,
    String shopId,
    String messenger,
    String whatsapp,
    String phone,
  ) async {
    await shared.setString(
        PsConst.VALUE_HOLDER__OVERALL_TAX_LABEL, overAllTaxLabel);
    await shared.setString(
        PsConst.VALUE_HOLDER__OVERALL_TAX_VALUE, overAllTaxValue);
    await shared.setString(
        PsConst.VALUE_HOLDER__SHIPPING_TAX_LABEL, shippingTaxLabel);
    await shared.setString(
        PsConst.VALUE_HOLDER__SHIPPING_TAX_VALUE, shippingTaxValue);
    await shared.setString(PsConst.VALUE_HOLDER__SHIPPING_ID, shippingId);
    await shared.setString(PsConst.VALUE_HOLDER__SHOP_ID, shopId);
    await shared.setString(PsConst.VALUE_HOLDER__MESSENGER, messenger);
    await shared.setString(PsConst.VALUE_HOLDER__WHATSAPP, whatsapp);
    await shared.setString(PsConst.VALUE_HOLDER__PHONE, phone);

    loadValueHolder();
  }

  Future<dynamic> replaceCheckoutEnable(
      String paypalEnabled,
      String stripeEnabled,
      String codEnabled,
      String bankEnabled,
      String standardShippingEnable,
      String zoneShippingEnable,
      String noShippingEnable) async {
    await shared.setString(PsConst.VALUE_HOLDER__PAYPAL_ENABLED, paypalEnabled);
    await shared.setString(PsConst.VALUE_HOLDER__STRIPE_ENABLED, stripeEnabled);
    await shared.setString(PsConst.VALUE_HOLDER__COD_ENABLED, codEnabled);
    await shared.setString(
        PsConst.VALUE_HOLDER__BANK_TRANSFER_ENABLE, bankEnabled);
    await shared.setString(
        PsConst.VALUE_HOLDER__STANDART_SHIPPING_ENABLE, standardShippingEnable);
    await shared.setString(
        PsConst.VALUE_HOLDER__ZONE_SHIPPING_ENABLE, zoneShippingEnable);
    await shared.setString(
        PsConst.VALUE_HOLDER__NO_SHIPPING_ENABLE, noShippingEnable);

    loadValueHolder();
  }

  Future<dynamic> replacePublishKey(String pubKey) async {
    await shared.setString(PsConst.VALUE_HOLDER__PUBLISH_KEY, pubKey);

    loadValueHolder();
  }

    Future<dynamic> replaceAdType(String adType) async {
    await shared.setString(PsConst.VALUE_HOLDER__AD_TYPE, adType);

    loadValueHolder();
  }

    Future<dynamic> replacePromoCellNo(String promoCellNo) async {
    await shared.setString(PsConst.VALUE_HOLDER__PROMO_CELL_NO, promoCellNo);

    loadValueHolder();
  }

    Future<dynamic> replaceIsUserAlreadyChoose(bool isUserAlreadyChoose) async {
    await shared.setBool(
        PsConst.VALUE_HOLDER__USER_ALREADY_CHOOSE, isUserAlreadyChoose);

    loadValueHolder();
  }
}
