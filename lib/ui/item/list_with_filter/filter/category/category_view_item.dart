

import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/viewobject/category.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';

class CategoryViewItem extends StatefulWidget {
  const CategoryViewItem(
      {Key? key, this.selectedData, this.category, required this.onCategoryClick})
      : super(key: key);
  final dynamic selectedData;
  final Category? category;
  final Function onCategoryClick;
  @override
  State<StatefulWidget> createState() => _CategoryViewItem();
}

class _CategoryViewItem extends State<CategoryViewItem> {
  late PsValueHolder valueHolder;
  bool isExpanded = false;

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

    return GestureDetector(
      onTap: () {
        final Map<String, String?> dataHolder = <String, String?>{};
        dataHolder[PsConst.CATEGORY_ID] = widget.category!.catId;
        dataHolder[PsConst.SUB_CATEGORY_ID] = '';
        dataHolder[PsConst.CATEGORY_NAME] = widget.category!.catName;
        widget.onCategoryClick(dataHolder);
      },
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            height: PsDimens.space52,
            color: PsColors.backgroundColor,
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
                                        icon: Icon(Icons.check_circle,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .copyWith(color: PsColors.activeColor)
                                                .color),
                                        onPressed: () {})
                                    : Container())
                          ]),
          ),
          Container(
              width: double.infinity,
              height: PsDimens.space2,
              color: Colors.black38,
            ),
        ],
      ),
    );

    // subCategoryRepository = Provider.of<SubCategoryRepository>(context);
    // valueHolder = Provider.of<PsValueHolder>(context);

    // return ChangeNotifierProvider<SubCategoryProvider>(
    //     lazy: false,
    //     create: (BuildContext context) {
    //       final SubCategoryProvider provider =
    //           SubCategoryProvider(repo: subCategoryRepository);
    //       provider.loadAllSubCategoryList(
    //           provider.subCategoryParameterHolder.toMap(),
    //           Utils.checkUserLoginId(valueHolder),
    //           widget.category!.catId);
    //       return provider;
    //     },
    //     child: Consumer<SubCategoryProvider>(builder:
    //         (BuildContext context, SubCategoryProvider provider, Widget? child) {
    //       return Container(
    //           child: custom.ExpansionTile(
    //         initiallyExpanded: false,
    //         headerBackgroundColor: PsColors.backgroundColor,
    //         title: Container(
    //           child: Row(
    //               mainAxisSize: MainAxisSize.max,
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: <Widget>[
    //                 Text(
    //                   widget.category!.catName!,
    //                   style: Theme.of(context).textTheme.subtitle2,
    //                 ),
    //                 Container(
    //                     child: widget.category!.catId ==
    //                             widget.selectedData[PsConst.CATEGORY_ID]
    //                         ? IconButton(
    //                             icon: Icon(Icons.playlist_add_check,
    //                                 color: Theme.of(context)
    //                                     .iconTheme
    //                                     .copyWith(color: PsColors.primary500)
    //                                     .color),
    //                             onPressed: () {})
    //                         : Container())
    //               ]),
    //         ),
    //         children: <Widget>[
    //           ListView.builder(
    //               shrinkWrap: true,
    //               physics: const NeverScrollableScrollPhysics(),
    //               itemCount: provider.subCategoryList.data!.length + 1,
    //               itemBuilder: (BuildContext context, int index) {
    //                 return ListTile(
    //                   title: Row(
    //                     mainAxisSize: MainAxisSize.max,
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: <Widget>[
    //                       Container(
    //                         child: Padding(
    //                           padding:
    //                               const EdgeInsets.only(left: PsDimens.space16),
    //                           child: index == 0
    //                               ? Text(
    //                                   Utils.getString(context,
    //                                           'product_list__category_all'),
    //                                   style:
    //                                       Theme.of(context).textTheme.bodyText1,
    //                                 )
    //                               : Text(
    //                                   provider
    //                                       .subCategoryList.data![index - 1].name!,
    //                                   style: Theme.of(context)
    //                                       .textTheme
    //                                       .bodyText1),
    //                         ),
    //                       ),
    //                       Container(
    //                           child: index == 0 &&
    //                                   widget.category!.catId ==
    //                                       widget.selectedData[
    //                                           PsConst.CATEGORY_ID] &&
    //                                   widget.selectedData[PsConst.SUB_CATEGORY_ID] ==
    //                                       ''
    //                               ? IconButton(
    //                                   icon: Icon(Icons.check_circle,
    //                                       color: Theme.of(context)
    //                                           .iconTheme
    //                                           .copyWith(
    //                                               color: PsColors.primary500)
    //                                           .color),
    //                                   onPressed: () {})
    //                               : index != 0 &&
    //                                       widget.selectedData[
    //                                               PsConst.SUB_CATEGORY_ID] ==
    //                                           provider.subCategoryList
    //                                               .data![index - 1].id
    //                                   ? IconButton(
    //                                       icon: Icon(Icons.check_circle,
    //                                           color: Theme.of(context)
    //                                               .iconTheme
    //                                               .color),
    //                                       onPressed: () {})
    //                                   : Container())
    //                     ],
    //                   ),
    //                   onTap: () {
    //                     final Map<String, String?> dataHolder =
    //                         <String, String?>{};
    //                     if (index == 0) {
    //                       // widget.onSubCategoryClick(dataHolder);
    //                       dataHolder[PsConst.CATEGORY_ID] =
    //                           widget.category!.catId;
    //                       dataHolder[PsConst.SUB_CATEGORY_ID] = '';
    //                       dataHolder[PsConst.CATEGORY_NAME] =
    //                           widget.category!.catName;
    //                       widget.onSubCategoryClick(dataHolder);
    //                     } else {
    //                       // widget.onSubCategoryClick(
    //                       //     provider.subCategoryList.data[index - 1]);
    //                       dataHolder[PsConst.CATEGORY_ID] =
    //                           widget.category!.catId;
    //                       dataHolder[PsConst.SUB_CATEGORY_ID] =
    //                           provider.subCategoryList.data![index - 1].id;
    //                       dataHolder[PsConst.CATEGORY_NAME] =
    //                           provider.subCategoryList.data![index - 1].name;
    //                       widget.onSubCategoryClick(dataHolder);
    //                     }
    //                   },
    //                 );
    //               }),
    //         ],
    //         onExpansionChanged: (bool expanding) =>
    //             setState(() => isExpanded = expanding),
    //       ));
    //     }));
  }
}
