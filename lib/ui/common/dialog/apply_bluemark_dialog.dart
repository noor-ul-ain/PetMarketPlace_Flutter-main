import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/provider/gallery/gallery_provider.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget_with_round_corner.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/apply_agent_parameter_holder.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ApplyBlueMarkDialog extends StatefulWidget {
  const ApplyBlueMarkDialog(this.galleryProvider);
  final GalleryProvider galleryProvider;
  @override
  _CertifiedDealerDialogState createState() => _CertifiedDealerDialogState();
}

class _CertifiedDealerDialogState extends State<ApplyBlueMarkDialog> {
  final TextEditingController agentNoteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            width: 380.0,
            padding: const EdgeInsets.symmetric(horizontal: PsDimens.space16, vertical: PsDimens.space8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: PsDimens.space8),
                Text(Utils.getString(context, 'apply_blue_mark_title'),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: PsColors.textColor1, fontWeight: FontWeight.bold)),
                const SizedBox(height: PsDimens.space16),
                Container(
                    margin: const EdgeInsets.only(
                      left: PsDimens.space16,
                      right: PsDimens.space16,
                    ),
                    // padding: const EdgeInsets.all(PsDimens.space14),
                    child: Text(
                      Utils.getString(
                          context, 'apply_blue_mark_verification_agent'),
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
                const SizedBox(height: PsDimens.space8),
                Container(
                  margin: const EdgeInsets.only(
                    left: PsDimens.space16,
                    right: PsDimens.space16,
                  ),
                  padding: const EdgeInsets.all(PsDimens.space10),
                  decoration: BoxDecoration(
                    color: PsColors.backgroundColor,
                    borderRadius: BorderRadius.circular(PsDimens.space4),
                    border: Border.all(color: PsColors.mainDividerColor),
                  ),
                  child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: 6,
                      style: Theme.of(context).textTheme.bodyLarge,
                      controller: agentNoteController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(PsDimens.space8),
                      //  hintText: Utils.getString(context, 'home_search__not_set'),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium?.copyWith(color: PsColors.textPrimaryLightColor),
                      )),
                ),
                //   PsTextFieldWidget(
      
                //       keyboardType: TextInputType.multiline,
                //       showTitle: false,
                //       hintText: Utils.getString(context, 'home_search__not_set'),
                //       textEditingController: agentNoteController),
                // ),
              //  const SizedBox(height: PsDimens.space8),
                Container(
                  margin: const EdgeInsets.only(
                    top: PsDimens.space16,
                    left: PsDimens.space16,
                    right: PsDimens.space16,
                    bottom: PsDimens.space8
                  ),
                  child: PSButtonWidgetRoundCorner(
                    colorData: PsColors.buttonColor,
                    hasShadow: true,
                    width: double.infinity,
                    titleText: Utils.getString(context, 'blue_mark_apply'),
                    onPressed: () async {
                      if (
                        //agentNoteController.text != null &&
                          agentNoteController.text.toString() != '') {
                        await PsProgressDialog.showDialog(context);
                        final PsValueHolder valueHolder =
                            Provider.of<PsValueHolder>(context, listen: false);
                        final ApplyAgentParameterHolder
                            applyAgentParameterHolder = ApplyAgentParameterHolder(
                                userId: valueHolder.loginUserId!,
                                note: agentNoteController.text);
                        final PsResource<ApiStatus> _apiStatus = await widget
                            .galleryProvider
                            .postApplyBlueMark(applyAgentParameterHolder.toMap());
                        PsProgressDialog.dismissDialog();
      
                        if (_apiStatus.data != null) {
                          Navigator.pop(context, true);
                          Fluttertoast.showToast(
                              msg: Utils.getString(
                                  context, 'success_dialog__success'),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: PsColors.primary500,
                              textColor: PsColors.white);
                        } else {
                          Navigator.pop(context, true);
                          Fluttertoast.showToast(
                              msg: 'result.message',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: PsColors.activeColor,
                              textColor: PsColors.textColor4);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: Utils.getString(context, 'enter_contact_info'),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: PsColors.activeColor,
                            textColor: PsColors.textColor4);
                      }
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: PsDimens.space16,
                    right: PsDimens.space16,
                    bottom: PsDimens.space8
                  ),
                  child: PSButtonWidgetRoundCorner(
                    colorData: PsColors.buttonColor,
                      hasShadow: true,
                      width: double.infinity,
                      titleText: Utils.getString(context, 'dialog__cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ],
            )),
      ),
    );
  }
}
