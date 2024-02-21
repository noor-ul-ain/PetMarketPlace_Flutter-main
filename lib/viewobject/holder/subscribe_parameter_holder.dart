
import 'package:flutterbuyandsell/viewobject/common/ps_holder.dart'
    show PsHolder;

class SubscribeParameterHolder
    extends PsHolder<SubscribeParameterHolder> {
  SubscribeParameterHolder({
    required this.userId,
    required this.catId,
    required this.selectedsubCatId,
  });
  final String userId;
  final String catId;
  final List<String?>  selectedsubCatId;
  
  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['user_id'] = userId;
    map['cat_id'] = catId;
    map['sub_cat_ids'] = selectedsubCatId;
    return map;
  }

  @override
  SubscribeParameterHolder fromMap(dynamic dynamicData) {
    return SubscribeParameterHolder(
      userId: dynamicData['user_id'],
      catId: dynamicData['cat_id'],
      selectedsubCatId: dynamicData['sub_cat_ids'],
    );
  }

  @override
  String getParamKey() {
    String key = '';

    if (userId != '') {
      key += userId;
    }
    if (catId != '') {
      key += catId;
    }
      if (selectedsubCatId.toString()  != '') {
      key += selectedsubCatId.toString();
    }

    return key;
  }
}


// class SubCatMap {
//   SubCatMap({
//     this.subcatId,
//   });

//   String? subcatId;

//   Map<String, dynamic> toMap() {
//     final Map<String, dynamic> map = <String, dynamic>{};

//     map['sub_cat_ids'] = subcatId;

//     return map;
//   }
// }
