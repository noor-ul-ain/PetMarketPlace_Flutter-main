import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/category.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_object.dart';
import 'package:flutterbuyandsell/viewobject/condition_of_item.dart';
import 'package:flutterbuyandsell/viewobject/deal_option.dart';
import 'package:flutterbuyandsell/viewobject/item_currency.dart';
import 'package:flutterbuyandsell/viewobject/item_location.dart';
import 'package:flutterbuyandsell/viewobject/item_price_type.dart';
import 'package:flutterbuyandsell/viewobject/item_type.dart';
import 'package:flutterbuyandsell/viewobject/rating_detail.dart';
import 'package:flutterbuyandsell/viewobject/sub_category.dart';
import 'package:flutterbuyandsell/viewobject/user.dart';
import 'package:quiver/core.dart';

import 'default_photo.dart';
import 'item_location_township.dart';

class Product extends PsObject<Product> {
  Product(
      {this.id,
        this.catId,
        this.subCatId,
        this.itemTypeId,
        this.itemPriceTypeId,
        this.itemCurrencyId,
        this.itemLocationId,
        this.itemLocationTownshipId,
        this.conditionOfItemId,
        this.dealOptionRemark,
        this.description,
        this.highlightInformation,
        this.price,
        this.dealOptionId,
        this.brand,
        this.businessMode,
        this.isSoldOut,
        this.title,
        this.address,
        this.whatsappNumber,
        this.lat,
        this.lng,
        this.status,
        this.addedDate,
        this.addedUserId,
        this.updatedDate,
        this.updatedUserId,
        this.updatedFlag,
        this.touchCount,
        this.favouriteCount,
        this.isPaid,
        this.dynamicLink,
        this.addedDateStr,
        this.paidStatus,
        this.photoCount,
        this.defaultPhoto,
        this.video,
        this.videoThumbnail,
        this.category,
        this.subCategory,
        this.itemType,
        this.itemPriceType,
        this.itemCurrency,
        this.itemLocation,
        this.itemLocationTownship,
        this.conditionOfItem,
        this.dealOption,
        this.user,
        this.ratingDetail,
        this.isFavourited,
        this.isOwner,
        this.discountRate,
        this.discountedPrice,
        this.adType});

  String? id;
  String? catId;
  String? subCatId;
  String? itemTypeId;
  String? itemPriceTypeId;
  String? itemCurrencyId;
  String? itemLocationId;
  String? itemLocationTownshipId;
  String? conditionOfItemId;
  String? dealOptionRemark;
  String? description;
  String? highlightInformation;
  String? price;
  String? dealOptionId;
  String? brand;
  String? businessMode;
  String? isSoldOut;
  String? title;
  String? address;
  String? whatsappNumber;
  String? lat;
  String? lng;
  String? status;
  String? addedDate;
  String? addedUserId;
  String? updatedDate;
  String? updatedUserId;
  String? updatedFlag;
  String? touchCount;
  String? favouriteCount;
  String? isPaid;
  String? dynamicLink;
  String? addedDateStr;
  String? paidStatus;
  String? photoCount;
  String? isFavourited;
  String? isOwner;
  String? discountRate;
  String? discountedPrice;
  DefaultPhoto? defaultPhoto;
  DefaultPhoto? video;
  DefaultPhoto? videoThumbnail;
  Category? category;
  SubCategory? subCategory;
  ItemType? itemType;
  ItemPriceType? itemPriceType;
  ItemCurrency? itemCurrency;
  ItemLocation? itemLocation;
  ItemLocationTownship? itemLocationTownship;
  ConditionOfItem? conditionOfItem;
  DealOption? dealOption;
  User? user;
  RatingDetail? ratingDetail;
  String? adType;
  @override
  bool operator ==(dynamic other) => other is Product && id == other.id;

  @override
  int get hashCode => hash2(id.hashCode, id.hashCode);

  @override
  String? getPrimaryKey() {
    return id;
  }

  @override
  Product fromMap(dynamic dynamicData) {
    // if (dynamicData != null) {
    return Product(
      id: dynamicData['id'],
      catId: dynamicData['cat_id'],
      subCatId: dynamicData['sub_cat_id'],
      itemTypeId: dynamicData['item_type_id'],
      itemPriceTypeId: dynamicData['item_price_type_id'],
      itemCurrencyId: dynamicData['item_currency_id'],
      itemLocationId: dynamicData['item_location_id'],
      itemLocationTownshipId: dynamicData['item_location_township_id'],
      conditionOfItemId: dynamicData['condition_of_item_id'],
      dealOptionRemark: dynamicData['deal_option_remark'],
      description: dynamicData['description'],
      highlightInformation: dynamicData['highlight_info'],
      price: dynamicData['price'],
      dealOptionId: dynamicData['deal_option_id'],
      brand: dynamicData['brand'],
      businessMode: dynamicData['business_mode'],
      isSoldOut: dynamicData['is_sold_out'],
      title: dynamicData['title'],
      address: dynamicData['address'],
      whatsappNumber: dynamicData['whatsapp'],
      lat: dynamicData['lat'],
      lng: dynamicData['lng'],
      status: dynamicData['status'],
      addedDate: dynamicData['added_date'],
      addedUserId: dynamicData['added_user_id'],
      updatedDate: dynamicData['updated_date'],
      updatedUserId: dynamicData['updated_user_id'],
      updatedFlag: dynamicData['updated_flag'],
      touchCount: dynamicData['touch_count'],
      favouriteCount: dynamicData['favourite_count'],
      isPaid: dynamicData['is_paid'],
      dynamicLink: dynamicData['dynamic_link'],
      addedDateStr: dynamicData['added_date_str'],
      paidStatus: dynamicData['paid_status'],
      photoCount: dynamicData['photo_count'],
      isFavourited: dynamicData['is_favourited'],
      isOwner: dynamicData['is_owner'],
      discountRate: dynamicData['discount_rate_by_percentage'],
      discountedPrice: dynamicData['discounted_price'],
      defaultPhoto: DefaultPhoto().fromMap(dynamicData['default_photo']),
      video: DefaultPhoto().fromMap(dynamicData['default_video']),
      videoThumbnail: DefaultPhoto().fromMap(dynamicData['default_video_icon']),
      category: Category().fromMap(dynamicData['category']),
      subCategory: SubCategory().fromMap(dynamicData['sub_category']),
      itemType: ItemType().fromMap(dynamicData['item_type']),
      itemPriceType: ItemPriceType().fromMap(dynamicData['item_price_type']),
      itemCurrency: ItemCurrency().fromMap(dynamicData['item_currency']),
      itemLocation: ItemLocation().fromMap(dynamicData['item_location']),
      itemLocationTownship:
      ItemLocationTownship().fromMap(dynamicData['item_location_township']),
      conditionOfItem:
      ConditionOfItem().fromMap(dynamicData['condition_of_item']),
      dealOption: DealOption().fromMap(dynamicData['deal_option']),
      user: User().fromMap(dynamicData['user']),
      ratingDetail: RatingDetail().fromMap(dynamicData['rating_details']),
      adType: dynamicData['ad_type'],
    );
    // }
    // else {
    //   return null;
    // }
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
    if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = object.id;
      data['cat_id'] = object.catId;
      data['sub_cat_id'] = object.subCatId;
      data['item_type_id'] = object.itemTypeId;
      data['item_price_type_id'] = object.itemPriceTypeId;
      data['item_currency_id'] = object.itemCurrencyId;
      data['item_location_id'] = object.itemLocationId;
      data['item_location_township_id'] = object.itemLocationTownshipId;
      data['condition_of_item_id'] = object.conditionOfItemId;
      data['deal_option_remark'] = object.dealOptionRemark;
      data['description'] = object.description;
      data['highlight_info'] = object.highlightInformation;
      data['price'] = object.price;
      data['deal_option_id'] = object.dealOptionId;
      data['brand'] = object.brand;
      data['business_mode'] = object.businessMode;
      data['is_sold_out'] = object.isSoldOut;
      data['title'] = object.title;
      data['address'] = object.address;
      data['whatsapp'] = object.whatsappNumber;
      data['lat'] = object.lat;
      data['lng'] = object.lng;
      data['status'] = object.status;
      data['added_date'] = object.addedDate;
      data['added_user_id'] = object.addedUserId;
      data['updated_date'] = object.updatedDate;
      data['updated_user_id'] = object.updatedUserId;
      data['updated_flag'] = object.updatedFlag;
      data['touch_count'] = object.touchCount;
      data['favourite_count'] = object.favouriteCount;
      data['is_paid'] = object.isPaid;
      data['dynamic_link'] = object.dynamicLink;
      data['added_date_str'] = object.addedDateStr;
      data['paid_status'] = object.paidStatus;
      data['photo_count'] = object.photoCount;
      data['is_favourited'] = object.isFavourited;
      data['is_owner'] = object.isOwner;
      data['discount_rate_by_percentage'] = object.discountRate;
      data['discounted_price'] = object.discountedPrice;
      data['default_photo'] = DefaultPhoto().toMap(object.defaultPhoto);
      data['default_video'] = DefaultPhoto().toMap(object.video);
      data['default_video_icon'] = DefaultPhoto().toMap(object.videoThumbnail);
      data['category'] = Category().toMap(object.category);
      data['sub_category'] = SubCategory().toMap(object.subCategory);
      data['item_type'] = ItemType().toMap(object.itemType);
      data['item_price_type'] = ItemPriceType().toMap(object.itemPriceType);
      data['item_currency'] = ItemCurrency().toMap(object.itemCurrency);
      data['item_location'] = ItemLocation().toMap(object.itemLocation);
      data['item_location_township'] =
          ItemLocationTownship().toMap(object.itemLocationTownship);
      data['condition_of_item'] =
          ConditionOfItem().toMap(object.conditionOfItem);
      data['deal_option'] = DealOption().toMap(object.dealOption);
      data['user'] = User().toMap(object.user);
      data['rating_details'] = RatingDetail().toMap(object.ratingDetail);
      data['ad_type'] = object.adType;
      return data;
    } else {
      return null;
    }
  }

  @override
  List<Product> fromMapList(List<dynamic> dynamicDataList) {
    final List<Product> newFeedList = <Product>[];
    // if (dynamicDataList != null) {
    for (dynamic json in dynamicDataList) {
      if (json != null) {
        newFeedList.add(fromMap(json));
      }
    }
    // }
    return newFeedList;
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<dynamic> objectList) {
    final List<Map<String, dynamic>?> dynamicList = <Map<String, dynamic>?>[];

    // if (objectList != null) {
    for (dynamic data in objectList) {
      if (data != null) {
        dynamicList.add(toMap(data));
      }
    }
    // }
    return dynamicList;
  }

  List<Product> checkDuplicate(List<Product> dataList) {
    final Map<String?, String?> idCache = <String?, String?>{};
    final List<Product> _tmpList = <Product>[];
    for (int i = 0; i < dataList.length; i++) {
      if (idCache[dataList[i].id] == null) {
        _tmpList.add(dataList[i]);
        idCache[dataList[i].id] = dataList[i].id;
      } else {
        Utils.psPrint('Duplicate');
      }
    }

    return _tmpList;
  }

  bool isSame(List<Product> cache, List<Product> newList) {
    if (cache.length == newList.length) {
      bool status = true;
      for (int i = 0; i < cache.length; i++) {
        if (cache[i].id != newList[i].id) {
          status = false;
          break;
        }
      }

      return status;
    } else {
      return false;
    }
  }
}