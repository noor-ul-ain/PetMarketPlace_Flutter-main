

import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_holder.dart';

class SubCategoryParameterHolder extends PsHolder<dynamic> {
  SubCategoryParameterHolder() {
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    keyword = '';
    catId = '';
  }

  String? orderBy;
  String? orderType;
  String? keyword;
  String? catId;

  SubCategoryParameterHolder getTrendingParameterHolder() {
    orderBy = PsConst.FILTERING__TRENDING;
    orderType = PsConst.FILTERING__DESC;
    keyword = '';
    catId = '';
    return this;
  }

  SubCategoryParameterHolder getLatestParameterHolder() {
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    keyword = '';
    catId = '';
    return this;
  }

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['order_by'] = orderBy;
    map['order_type'] = orderType;
    map['keyword'] = keyword;
    map['cat_id'] = catId;
    return map;
  }

  @override
  dynamic fromMap(dynamic dynamicData) {
    orderBy = PsConst.FILTERING__ADDED_DATE;
    orderType = PsConst.FILTERING__DESC;
    keyword = dynamicData['keyword'];
    catId = dynamicData['cat_id'];
    return this;
  }

  @override
  String getParamKey() {
    String result = '';

    if (orderBy != '') {
      result += orderBy! + ':';
    }
    if (orderType != '') {
      result += orderType! + ':';
    }
    if (keyword != '') {
      result += keyword!;
    }
    if (catId != '') {
      result += catId!;
    }

    return result;
  }
}
