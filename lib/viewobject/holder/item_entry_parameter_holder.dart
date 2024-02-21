import 'package:flutterbuyandsell/viewobject/common/ps_holder.dart'
    show PsHolder;

class ItemEntryParameterHolder extends PsHolder<ItemEntryParameterHolder> {
  ItemEntryParameterHolder({
    this.catId,
    this.subCatId,
    this.itemTypeId,
    this.itemPriceTypeId,
    this.itemCurrencyId,
    this.conditionOfItemId,
    this.itemLocationId,
    this.itemLocationTownshipId,
    this.dealOptionRemark,
    this.description,
    this.highlightInfomation,
    this.price,
    this.discountRate,
    this.dealOptionId,
    this.brand,
    this.businessMode,
    this.isSoldOut,
    this.title,
    this.address,
    this.whatsappNumber,
    this.latitude,
    this.longitude,
    this.id,
    this.addedUserId,
    this.status,
  });

  final String? catId;
  final String? subCatId;
  final String? itemTypeId;
  final String? itemPriceTypeId;
  final String? itemCurrencyId;
  final String? conditionOfItemId;
  final String? itemLocationId;
  final String? itemLocationTownshipId;
  final String? dealOptionRemark;
  final String? description;
  final String? highlightInfomation;
  final String? price;
  final String? discountRate;
  final String? dealOptionId;
  final String? brand;
  final String? businessMode;
  final String? isSoldOut;
  final String? title;
  final String? address;
  final String? whatsappNumber;
  final String? latitude;
  final String? longitude;
  final String? id;
  final String? addedUserId;
  final String? status;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['cat_id'] = catId;
    map['sub_cat_id'] = subCatId;
    map['item_type_id'] = itemTypeId;
    map['item_price_type_id'] = itemPriceTypeId;
    map['item_currency_id'] = itemCurrencyId;
    map['condition_of_item_id'] = conditionOfItemId;
    map['item_location_id'] = itemLocationId;
    map['item_location_township_id'] = itemLocationTownshipId;
    map['deal_option_remark'] = dealOptionRemark;
    map['description'] = description;
    map['highlight_info'] = highlightInfomation;
    map['price'] = price;
    map['discount_rate_by_percentage'] = discountRate;
    map['deal_option_id'] = dealOptionId;
    map['brand'] = brand;
    map['business_mode'] = businessMode;
    map['is_sold_out'] = isSoldOut;
    map['title'] = title;
    map['address'] = address;
    map['whatsapp'] = whatsappNumber;
    map['lat'] = latitude;
    map['lng'] = longitude;
    map['id'] = id;
    map['added_user_id'] = addedUserId;
    map['status'] = status;

    return map;
  }

  @override
  ItemEntryParameterHolder fromMap(dynamic dynamicData) {
    return ItemEntryParameterHolder(
      catId: dynamicData['cat_id'],
      subCatId: dynamicData['sub_cat_id'],
      itemTypeId: dynamicData['item_type_id'],
      itemPriceTypeId: dynamicData['item_price_type_id'],
      itemCurrencyId: dynamicData['item_currency_id'],
      conditionOfItemId: dynamicData['condition_of_item_id'],
      itemLocationId: dynamicData['item_location_id'],
      itemLocationTownshipId: dynamicData['item_location_township_id'],
      dealOptionRemark: dynamicData['deal_option_remark'],
      description: dynamicData['description'],
      highlightInfomation: dynamicData['highlight_info'],
      price: dynamicData['price'],
      discountRate: dynamicData['discount_rate_by_percentage'],
      dealOptionId: dynamicData['deal_option_id'],
      brand: dynamicData['brand'],
      businessMode: dynamicData['business_mode'],
      isSoldOut: dynamicData['is_sold_out'],
      title: dynamicData['title'],
      address: dynamicData['address'],
      whatsappNumber: dynamicData['whatsapp'],
      latitude: dynamicData['lat'],
      longitude: dynamicData['lng'],
      id: dynamicData['id'],
      addedUserId: dynamicData['added_user_id'],
      status: dynamicData['status'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (catId != '') {
      key += catId!;
    }
    if (subCatId != '') {
      key += subCatId!;
    }
    if (itemTypeId != '') {
      key += itemTypeId!;
    }
    if (itemPriceTypeId != '') {
      key += itemPriceTypeId!;
    }
    if (itemCurrencyId != '') {
      key += itemCurrencyId!;
    }
    if (conditionOfItemId != '') {
      key += conditionOfItemId!;
    }
    if (itemLocationId != '') {
      key += itemLocationId!;
    }
    if (dealOptionRemark != '') {
      key += dealOptionRemark!;
    }
    if (description != '') {
      key += description!;
    }
    if (highlightInfomation != '') {
      key += highlightInfomation!;
    }
    if (price != '') {
      key += price!;
    }
    if (discountRate != '') {
      key += discountRate!;
    }
    if (dealOptionId != '') {
      key += dealOptionId!;
    }
    if (brand != '') {
      key += brand!;
    }
    if (businessMode != '') {
      key += businessMode!;
    }
    if (isSoldOut != '') {
      key += isSoldOut!;
    }
    if (title != '') {
      key += title!;
    }
    if (address != '') {
      key += address!;
    }
    if (whatsappNumber != '') {
      key += whatsappNumber!;
    }
    if (latitude != '') {
      key += latitude!;
    }
    if (longitude != '') {
      key += longitude!;
    }
    if (id != '') {
      key += id!;
    }
    if (addedUserId != '') {
      key += addedUserId!;
    }
    if (status != '') {
      key += status!;
    }
    return key;
  }
}