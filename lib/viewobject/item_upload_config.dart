import 'package:quiver/core.dart';
import 'common/ps_object.dart';


class ItemUploadConfig extends PsObject<ItemUploadConfig> {
  ItemUploadConfig({
    this.title, this.description, this.price, this.itemCurrencyId, this.locationId,
    this.categoryId, this.image, this.address, this.brand, this.latitude, this.longitude,
    this.businessMode, this.subCatId, this.typeId, this.priceTypeId,
    this.conditionOfItemId, this.dealOptionId, this.dealOptionRemark, this.highlightInfo,
    this.video, this.videoIcon,this.discountRateByPercentage
  });

  String? title; String? description; String? price; String? itemCurrencyId; String? locationId;
  String? categoryId; String? image; String? address; String? brand; String? latitude; String? longitude;
  String? businessMode; String? subCatId; String? typeId; String? priceTypeId;
  String? conditionOfItemId; String? dealOptionId; String? dealOptionRemark; String? highlightInfo;
  String? video; String? videoIcon; String? discountRateByPercentage;

  @override
  bool operator ==(dynamic other) => other is ItemUploadConfig && title == other.title;

  @override
  int get hashCode => hash2(title.hashCode, title.hashCode);

  @override
  String? getPrimaryKey() {
    return title;
  }

  @override
  ItemUploadConfig fromMap(dynamic dynamicData) {
    return ItemUploadConfig(
      title: dynamicData['title'],
      description: dynamicData['description'],
      price: dynamicData['price'],
      itemCurrencyId: dynamicData['item_currency_id'],
      locationId: dynamicData['item_location_id'], 
      categoryId: dynamicData['cat_id'],
      image: dynamicData['image'],
      address: dynamicData['address'],
      brand: dynamicData['brand'],
      latitude: dynamicData['lat'],
      longitude: dynamicData['lng'],
      businessMode: dynamicData['business_mode'],
      subCatId: dynamicData['sub_cat_id'],
      typeId: dynamicData['item_type_id'],
      priceTypeId: dynamicData['item_price_type_id'],
      conditionOfItemId: dynamicData['condition_of_item_id'],
      dealOptionId: dynamicData['deal_option_id'],
      dealOptionRemark: dynamicData['deal_option_remark'],
      highlightInfo: dynamicData['highlight_info'],
      video: dynamicData['video'],
      videoIcon: dynamicData['video_icon'],
      discountRateByPercentage: dynamicData['discount_rate_by_percentage']

    );
  }

  @override
  Map<String, dynamic>? toMap(dynamic object) {
   if (object != null) {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['title'] = object.title;
      data['description'] = object.description;
      data['price'] = object.price;
      data['item_currency_id'] = object.itemCurrencyId;
      data['item_location_id'] = object.locationId;
      data['cat_id'] = object.categoryId;
      data['image'] = object.image;
      data['address'] = object.address;
      data['brand'] = object.brand; 
      data['lat'] = object.latitude;
      data['lng'] = object.longitude;
      data['business_mode'] = object.businessMode;
      data['sub_cat_id'] = object.subCatId;
      data['item_type_id'] = object.typeId;
      data['item_price_type_id'] = object.priceTypeId;
      data['condition_of_item_id'] = object.conditionOfItemId;
      data['deal_option_id'] = object.dealOptionId; 
      data['deal_option_remark'] = object.dealOptionRemark;
      data['highlight_info'] = object.highlightInfo; 
      data['video'] = object.video;
      data['video_icon'] = object.videoIcon;
      data['discount_rate_by_percentage']= object.discountRateByPercentage;
      return data;
    } else {
      return null;
    }
  }
    
  @override
  List<ItemUploadConfig> fromMapList(List<dynamic> dynamicDataList) {
    final List<ItemUploadConfig> userLoginList = <ItemUploadConfig>[];

    // if (dynamicDataList != null) {
    for (dynamic dynamicData in dynamicDataList) {
      if (dynamicData != null) {
        userLoginList.add(fromMap(dynamicData));
      }
    }
    // }
    return userLoginList;
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

}