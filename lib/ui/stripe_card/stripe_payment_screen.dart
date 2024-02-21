import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/credit_card_model.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/provider/app_info/app_info_provider.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar_with_no_provider.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

class StripePaymentScreen extends StatefulWidget {
  const StripePaymentScreen({Key? key}) : super(key: key);

  @override
  State<StripePaymentScreen> createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  // CardFieldInputDetails? cardData;
  String publishKey = '';
  @override
  void initState() {
    // StripePayment.setOptions(StripeOptions(
    //     publishableKey: widget.stripePublishableKey,
    //     merchantId: 'Test',
    //     androidPayMode: 'test'));
    super.initState();
  }

  void setError(dynamic error) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return ErrorDialog(
            message: Utils.getString(context, error.toString()),
          );
        });
  }

  dynamic callWarningDialog(BuildContext context, String text) {
    showDialog<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return WarningDialog(
            message: Utils.getString(context, text),
            onPressed: () {},
          );
        });
  }

  dynamic stripeNow(String token) async {
   Navigator.pop(context,token);
  }

  @override
  Widget build(BuildContext context) {
    return PsWidgetWithAppBarWithNoProvider(
    appBarTitle: Utils.getString(context, 'item_promote__credit_card_title'),
    child: Column(
      children: <Widget>[
        // Container(
        //   padding: const EdgeInsets.all(PsDimens.space16),
        //   child: CardField(
        //     autofocus: false,
        //     onCardChanged: (CardFieldInputDetails? card) async {
        //       setState(() {
        //         cardData = card;
        //       });
        //     },
        //   ),
        // ),
        // Container(
        //   margin: const EdgeInsets.only(left: PsDimens.space12, right: PsDimens.space12),
        //   child: PSButtonWidget(
        //     hasShadow: true,
        //     width: double.infinity,
        //     titleText: Utils.getString(context, 'credit_card__pay'),
        //     onPressed: () async {
        //       if (cardData != null && cardData!.complete) {
        //
        //         await PsProgressDialog.showDialog(context);
        //         Stripe.publishableKey = AppInfoProvider.publishKey;
        //         const PaymentMethodParams paymentMethodParams =
        //         PaymentMethodParams.card(
        //             paymentMethodData: PaymentMethodData(
        //                 billingDetails: BillingDetails()));
        //
        //         final PaymentMethod paymentMethod = await Stripe.instance
        //             .createPaymentMethod(params: paymentMethodParams);
        //         Utils.psPrint(paymentMethod.id);
        //
        //         // String paymentId = await createCard(cardData!, AppInfoProvider.publishKey);
        //
        //         PsProgressDialog.dismissDialog();
        //         await stripeNow(paymentMethod.id);
        //       } else {
        //         callWarningDialog(context, Utils.getString(context, 'contact_us__fail'));
        //       }
        //     },
        //   ),
        // ),
      ],
    ),
    );
  }

  // void onCreditCardModelChange(CreditCardModel creditCardModel) {
  //   setState(() {
  //     cardNumber = creditCardModel.cardNumber;
  //     expiryDate = creditCardModel.expiryDate;
  //     cardHolderName = creditCardModel.cardHolderName;
  //     cvvCode = creditCardModel.cvvCode;
  //     isCvvFocused = creditCardModel.isCvvFocused;
  //   });
  // }
}
