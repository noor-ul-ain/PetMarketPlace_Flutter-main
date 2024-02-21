


import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_holder.dart';

class ProductParameterHolder extends PsHolder<dynamic> {
  ProductParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationName = '';
    itemLocationId = '';
    itemLocationTownshipId = '';
    dealOptionId = '';
    isSoldOut = '';
    conditionOfItemId = '';
    conditionOfItemName = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    addedUserId = '';
    isPaid = '';
    status = '1';
    isDiscount = '';
    adType = '';
  }

  String? searchTerm;
  String? catId;
  String? subCatId;
  String? itemTypeId;
  String? itemPriceTypeId;
  String? itemCurrencyId;
  String? itemLocationId;
  String? itemLocationName;
  String? itemLocationTownshipId;
  String? itemLocationTownshipName;
  String? dealOptionId;
  String? isSoldOut;
  String? conditionOfItemId;
  String? conditionOfItemName;
  String? maxPrice;
  String? minPrice;
  String? brand;
  String? lat;
  String? lng;
  String? mile;
  String? orderBy;
  String? orderType;
  String? addedUserId;
  String? isPaid;
  String? status;
  String? isDiscount;
  String? adType;

  bool isFiltered() {
    return !(
        // isAvailable == '' &&
        //   (isDiscount == '0' || isDiscount == '') &&
        //   (isFeatured == '0' || isFeatured == '') &&
        orderBy == '' &&
            orderType == '' &&
            minPrice == '' &&
            maxPrice == '' &&
            itemTypeId == '' &&
            conditionOfItemId == '' &&
            itemPriceTypeId == '' &&
            dealOptionId == '' &&
            isSoldOut == '' &&
            searchTerm == '' &&
            lat == '' &&
            lng == '' &&
            mile == '');
  }

  bool isCatAndSubCatFiltered() {
    return !(catId == '' && subCatId == '');
  }

  ProductParameterHolder getRecentParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    dealOptionId = '';
    isSoldOut = '';
    conditionOfItemId = '';
    conditionOfItemName = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';
    adType = '';

    return this;
  }

    ProductParameterHolder getSoldOutParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    dealOptionId = '';
    isSoldOut = '1';
    conditionOfItemId = '';
    conditionOfItemName = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';
    adType = '';
        return this;
  }

    ProductParameterHolder getNearestParameterHolder() {
    searchTerm = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';
    adType = '';

    return this;
  }

  ProductParameterHolder getPaidItemParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    dealOptionId = '';
    isSoldOut = '';
    conditionOfItemId = '';
    conditionOfItemName = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = PsConst.ONLY_PAID_ITEM;
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';
    adType = '';

    return this;
  }

  ProductParameterHolder getPendingItemParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    dealOptionId = '';
    isSoldOut = '';
    conditionOfItemId = '';
    conditionOfItemName = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '0';
    isDiscount = '';
    adType = '';

    return this;
  }

  ProductParameterHolder getRejectedItemParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    dealOptionId = '';
    isSoldOut = '';
    conditionOfItemId = '';
    conditionOfItemName = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '3';
    isDiscount = '';
    adType = '';

    return this;
  }

  ProductParameterHolder getDisabledProductParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    dealOptionId = '';
    isSoldOut = '';
    conditionOfItemId = '';
        conditionOfItemName = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '2';
    isDiscount = '';
    adType = '';

    return this;
  }

  ProductParameterHolder getFeaturedParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    dealOptionId = '';
    isSoldOut = '';
    conditionOfItemId = '';
        conditionOfItemName = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING_FEATURE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';
    adType = '';

    return this;
  }

  ProductParameterHolder getPopularParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    dealOptionId = '';
    isSoldOut = '';
    conditionOfItemId = '';
    conditionOfItemName = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING_TRENDING;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';
    adType = '';

    return this;
  }

  ProductParameterHolder getLatestParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    dealOptionId = '';
    isSoldOut = '';
    conditionOfItemId = '';
        conditionOfItemName = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';
    adType = '';

    return this;
  }

  ProductParameterHolder getDiscountParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    dealOptionId = '';
    isSoldOut = '';
    conditionOfItemId = '';
        conditionOfItemName = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '1';
    adType = '';

    return this;
  }

  ProductParameterHolder resetParameterHolder() {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationName = '';
    itemLocationTownshipId = '';
    itemLocationTownshipName = '';
    dealOptionId = '';
    isSoldOut = '';
    conditionOfItemId = '';
        conditionOfItemName = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '1';
    isDiscount = '';
    adType = '';

    return this;
  }

  

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['searchterm'] = searchTerm;
    map['cat_id'] = catId;
    map['sub_cat_id'] = subCatId;
    map['item_type_id'] = itemTypeId;
    map['item_price_type_id'] = itemPriceTypeId;
    map['item_currency_id'] = itemCurrencyId;
    map['item_location_id'] = itemLocationId;
    map['item_location_township_id'] = itemLocationTownshipId;
    map['deal_option_id'] = dealOptionId;
    map['is_sold_out'] = isSoldOut;
    map['condition_of_item_id'] = conditionOfItemId;
    map['max_price'] = maxPrice;
    map['min_price'] = minPrice;
    map['brand'] = brand;
    map['lat'] = lat;
    map['lng'] = lng;
    map['miles'] = mile;
    map['added_user_id'] = addedUserId;
    map['ad_post_type'] = isPaid;
    map['order_by'] = orderBy;
    map['order_type'] = orderType;
    map['status'] = status;
    map['is_discount'] = isDiscount;
    map['ad_type'] = adType;
    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    searchTerm = '';
    catId = '';
    subCatId = '';
    itemTypeId = '';
    itemPriceTypeId = '';
    itemCurrencyId = '';
    itemLocationId = '';
    itemLocationTownshipId = '';
    dealOptionId = '';
    isSoldOut = '';
    conditionOfItemId = '';
        conditionOfItemName = '';
    maxPrice = '';
    minPrice = '';
    brand = '';
    lat = '';
    lng = '';
    mile = '';
    addedUserId = '';
    isPaid = '';
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    status = '';
    isDiscount = '';
    adType = '';

    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (searchTerm != '') {
      result += searchTerm! + ':';
    }
    if (catId != '') {
      result += catId! + ':';
    }
    if (subCatId != '') {
      result += subCatId! + ':';
    }
    if (itemTypeId != '') {
      result += itemTypeId! + ':';
    }
    if (itemPriceTypeId != '') {
      result += itemPriceTypeId! + ':';
    }
    if (itemCurrencyId != '') {
      result += itemCurrencyId! + ':';
    }
    if (itemLocationId != '') {
      result += itemLocationId! + ':';
    }
    if (itemLocationTownshipId != '') {
      result += itemLocationTownshipId! + ':';
    }
    if (dealOptionId != '') {
      result += dealOptionId! + ':';
    }
    if (isSoldOut != '') {
      result += isSoldOut! + ':';
    }
    if (conditionOfItemId != '') {
      result += conditionOfItemId! + ':';
    }

       if ( conditionOfItemName != '') {
        result += conditionOfItemName! + ':';
       }
    if (maxPrice != '') {
      result += maxPrice! + ':';
    }
    if (minPrice != '') {
      result += minPrice! + ':';
    }
    if (brand != '') {
      result += brand! + ':';
    }
    if (lat != '') {
      result += lat! + ':';
    }
    if (lng != '') {
      result += lng! + ':';
    }
    if (mile != '') {
      result += mile! + ':';
    }
    if (addedUserId != '') {
      result += addedUserId! + ':';
    }
    if (status != '') {
      result += status! + ':';
    }
    if (isPaid != '') {
      result += isPaid! + ':';
    }
    if (orderBy != '') {
      result += orderBy! + ':';
    }
    if (orderType != '') {
      result += orderType!;
    }
    if (isDiscount != '') {
      result += isDiscount!;
    }
        if (adType != '') {
      result += adType!;
    }

    return result;
  }
}
