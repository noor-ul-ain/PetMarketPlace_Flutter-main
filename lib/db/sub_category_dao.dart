

import 'package:flutterbuyandsell/db/common/ps_dao.dart';
import 'package:flutterbuyandsell/viewobject/sub_category.dart';
import 'package:sembast/sembast.dart';

class SubCategoryDao extends PsDao<SubCategory> {
  SubCategoryDao() {
    init(SubCategory());
  }

  static const String STORE_NAME = 'SubCategory';
  final String _primaryKey = 'id';

  @override
  String? getPrimaryKey(SubCategory object) {
    return object.id;
  }

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  Filter getFilter(SubCategory object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
