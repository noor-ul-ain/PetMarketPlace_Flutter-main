import 'package:flutterbuyandsell/viewobject/common/ps_holder.dart'
    show PsHolder;

class BlogParameterHolder extends PsHolder<BlogParameterHolder> {
  BlogParameterHolder() {
    searchTerm = '';
    cityId = '';
  }

  String? searchTerm;
  String? cityId;

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['searchterm'] = searchTerm;
    map['city_id'] = cityId;

    return map;
  }

  @override
  BlogParameterHolder fromMap(dynamic dynamicData) {
    searchTerm = '';
    cityId = '';
    return this;
  }

  @override
  String getParamKey() {
    String key = '';

    if (searchTerm != '') {
      key += searchTerm! + ':';
    }
    if (cityId != '') {
      key += cityId ?? '';
    }
    return key;
  }
}
