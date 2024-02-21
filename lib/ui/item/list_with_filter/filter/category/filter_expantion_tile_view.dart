

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/provider/subcategory/sub_category_provider.dart';
import 'package:flutterbuyandsell/repository/sub_category_repository.dart';
import 'package:flutterbuyandsell/ui/common/expansion_tile.dart' as custom;
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/category.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';

class FilterExpantionTileView extends StatefulWidget {
  const FilterExpantionTileView(
      {Key? key, this.selectedData, this.category, required this.onSubCategoryClick})
      : super(key: key);
  final dynamic selectedData;
  final Category? category;
  final Function onSubCategoryClick;
  @override
  State<StatefulWidget> createState() => _FilterExpantionTileView();
}

class _FilterExpantionTileView extends State<FilterExpantionTileView> {
  SubCategoryRepository? subCategoryRepository;
   PsValueHolder? valueHolder;
  bool isExpanded = false;
//  SubCategoryProvider? _subCategoryProvider;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    subCategoryRepository = Provider.of<SubCategoryRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);

    return ChangeNotifierProvider<SubCategoryProvider>(
        lazy: false,
        create: (BuildContext context) {
          final SubCategoryProvider provider =
              SubCategoryProvider(repo: subCategoryRepository);
          provider.subCategoryParameterHolder.catId = widget.category!.catId;
          provider.categoryId = widget.category!.catId!;
          provider.loadAllSubCategoryList(
              provider.subCategoryParameterHolder.toMap(),
             valueHolder!.loginUserId ?? '',);
          return provider;
        },
        child: Consumer<SubCategoryProvider>(builder:
            (BuildContext context, SubCategoryProvider provider, Widget? child) {
          return Container(
              child: custom.ExpansionTile(
            initiallyExpanded: false,
            headerBackgroundColor: PsColors.backgroundColor,
            title: Container(
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.category!.catName!,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Container(
                        child: widget.category!.catId ==
                                widget.selectedData[PsConst.CATEGORY_ID]
                            ? IconButton(
                                icon: Icon(Icons.playlist_add_check,
                                    color: Theme.of(context)
                                        .iconTheme
                                        .copyWith(color: PsColors.activeColor)
                                        .color),
                                onPressed: () {})
                            : Container())
                  ]),
            ),
            children: <Widget>[
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.subCategoryList.data!.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: PsDimens.space16),
                              child: index == 0
                                  ? Text(
                                      Utils.getString(context,
                                              'product_list__category_all'),
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    )
                                  : Text(
                                      provider
                                          .subCategoryList.data![index - 1].name!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                            ),
                          ),
                          Container(
                              child: index == 0 &&
                                      widget.category!.catId ==
                                          widget.selectedData[
                                              PsConst.CATEGORY_ID] &&
                                      widget.selectedData[PsConst.SUB_CATEGORY_ID] ==
                                          ''
                                  ? IconButton(
                                      icon: Icon(Icons.check_circle,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .copyWith(
                                                  color: PsColors.activeColor)
                                              .color),
                                      onPressed: () {})
                                  : index != 0 &&
                                          widget.selectedData[
                                                  PsConst.SUB_CATEGORY_ID] ==
                                              provider.subCategoryList
                                                  .data![index - 1].id
                                      ? IconButton(
                                          icon: Icon(Icons.check_circle,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color),
                                          onPressed: () {})
                                      : Container())
                        ],
                      ),
                      onTap: () {
                        final Map<String, String?> dataHolder =
                            <String, String?>{};
                        if (index == 0) {
                          // widget.onSubCategoryClick(dataHolder);
                          dataHolder[PsConst.CATEGORY_ID] =
                              widget.category!.catId;
                          dataHolder[PsConst.SUB_CATEGORY_ID] = '';
                          dataHolder[PsConst.CATEGORY_NAME] =
                              widget.category!.catName;
                          widget.onSubCategoryClick(dataHolder);
                        } else {
                          // widget.onSubCategoryClick(
                          //     provider.subCategoryList.data[index - 1]);
                          dataHolder[PsConst.CATEGORY_ID] =
                              widget.category!.catId;
                          dataHolder[PsConst.SUB_CATEGORY_ID] =
                              provider.subCategoryList.data![index - 1].id;
                          dataHolder[PsConst.CATEGORY_NAME] =
                              provider.subCategoryList.data![index - 1].name;
                          widget.onSubCategoryClick(dataHolder);
                        }
                      },
                    );
                  }),
            ],
            onExpansionChanged: (bool expanding) =>
                setState(() => isExpanded = expanding),
          ));
        }));
  }
}
