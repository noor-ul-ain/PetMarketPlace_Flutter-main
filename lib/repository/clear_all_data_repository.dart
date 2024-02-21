import 'dart:async';

import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/db/about_us_dao.dart';
import 'package:flutterbuyandsell/db/blog_dao.dart';
import 'package:flutterbuyandsell/db/category_map_dao.dart';
import 'package:flutterbuyandsell/db/cateogry_dao.dart';
import 'package:flutterbuyandsell/db/chat_history_dao.dart';
import 'package:flutterbuyandsell/db/chat_history_map_dao.dart';
import 'package:flutterbuyandsell/db/product_dao.dart';
import 'package:flutterbuyandsell/db/product_map_dao.dart';
import 'package:flutterbuyandsell/db/rating_dao.dart';
import 'package:flutterbuyandsell/db/related_product_dao.dart';
import 'package:flutterbuyandsell/db/sub_category_dao.dart';
import 'package:flutterbuyandsell/db/user_unread_message_dao.dart';
import 'package:flutterbuyandsell/repository/Common/ps_repository.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';

class ClearAllDataRepository extends PsRepository {
  Future<dynamic> clearAllData(
      StreamController<PsResource<List<Product>>> allListStream) async {
    final ProductDao _productDao = ProductDao.instance;
    final CategoryDao _categoryDao = CategoryDao();
    final CategoryMapDao _categoryMapDao = CategoryMapDao.instance;
    final ProductMapDao _productMapDao = ProductMapDao.instance;
    final RatingDao _ratingDao = RatingDao.instance;
    final SubCategoryDao _subCategoryDao = SubCategoryDao();
    final BlogDao _blogDao = BlogDao.instance;
    final ChatHistoryDao _chatHistoryDao = ChatHistoryDao.instance;
    final ChatHistoryMapDao _chatHistoryMapDao = ChatHistoryMapDao.instance;
    final UserUnreadMessageDao _userUnreadMessageDao =
        UserUnreadMessageDao.instance;
    final RelatedProductDao _relatedProductDao = RelatedProductDao.instance;
    final AboutUsDao _aboutUsDao = AboutUsDao.instance;
    await _productDao.deleteAll();
    await _blogDao.deleteAll();
    await _categoryDao.deleteAll();
    await _categoryMapDao.deleteAll();
    await _productMapDao.deleteAll();
    await _ratingDao.deleteAll();
    await _subCategoryDao.deleteAll();
    await _chatHistoryDao.deleteAll();
    await _chatHistoryMapDao.deleteAll();
    await _userUnreadMessageDao.deleteAll();
    await _relatedProductDao.deleteAll();
    await _aboutUsDao.deleteAll();

    allListStream.sink.add(await _productDao.getAll(status: PsStatus.SUCCESS));
  }
}
