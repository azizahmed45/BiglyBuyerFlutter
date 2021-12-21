import 'package:flutter/material.dart';
import 'package:bigly24/provider/order_provider.dart';
import 'package:bigly24/helper/date_converter.dart';

import 'package:bigly24/localization/language_constrants.dart';
import 'package:bigly24/utill/app_constants.dart';
import 'package:bigly24/utill/color_resources.dart';
import 'package:bigly24/utill/custom_themes.dart';
import 'package:bigly24/utill/dimensions.dart';
import 'package:bigly24/view/basewidget/custom_app_bar.dart';
import 'package:bigly24/view/basewidget/custom_loader.dart';
import 'package:bigly24/view/screen/dashboard/dashboard_screen.dart';
import 'package:bigly24/view/screen/tracking/painter/line_dashed_painter.dart';
import 'package:provider/provider.dart';

class TrackingResultScreen extends StatelessWidget {
  final String orderID;
  TrackingResultScreen({@required this.orderID});

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderProvider>(context, listen: false).initTrackingInfo(orderID, null, false, context);
    List<String> _statusList = ['pending', 'confirmed', 'processing', 'out_for_delivery', 'delivered'];


    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Column(
        children: [
          CustomAppBar(title: getTranslated('DELIVERY_STATUS', context)),

          Expanded(
            child: Consumer<OrderProvider>(
              builder: (context, tracking, child) {
                String status = tracking.trackingModel != null ? tracking.trackingModel.orderStatus : '';
                DateTime date = tracking.trackingModel != null ? DateConverter.isoStringToLocalDate(tracking.trackingModel.createdAt).add(Duration(days: 7)) : DateTime.now();

                return tracking.trackingModel != null
                    ? _statusList.contains(status) ? ListView(
                  physics: BouncingScrollPhysics(),
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(getTranslated('ESTIMATED_DELIVERY', context), style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                              Text(DateConverter.estimatedDate(date), style: titilliumSemiBold.copyWith(fontSize: 20.0)),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.all(Dimensions.MARGIN_SIZE_DEFAULT),
                            decoration: BoxDecoration(color: Theme.of(context).highlightColor, borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // for parcel status and order id section
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(getTranslated('PARCEL_STATUS', context), style: titilliumSemiBold),
                                      RichText(
                                        text: TextSpan(
                                          text: getTranslated('ORDER_ID', context),
                                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                          children: <TextSpan>[
                                            TextSpan(text: orderID, style: titilliumSemiBold),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                  color: ColorResources.getPrimary(context),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                                // Steppers
                                CustomStepper(
                                    title: status == 'pending' ? getTranslated('processing', context) : getTranslated('ORDER_PLACED_PREPARING', context),
                                    color: ColorResources.getHarlequin(context)),
                                CustomStepper(
                                    title: status == 'pending'
                                        ? getTranslated('pending', context)
                                        : status == 'confirmed' ? getTranslated('processing', context) : getTranslated('ORDER_PICKED_SENDING', context),
                                    color: ColorResources.getCheris(context)),
                                CustomStepper(
                                    title: status == 'pending'
                                        ? getTranslated('pending', context)
                                        : status == 'confirmed'
                                            ? getTranslated('pending', context)
                                            : status == 'processing' ? getTranslated('processing', context) : getTranslated('RECEIVED_LOCAL_WAREHOUSE', context),
                                    color: ColorResources.getColombiaBlue(context)),
                                CustomStepper(
                                    title:status == 'pending'
                                        ? getTranslated('pending', context)
                                        : status == 'confirmed'
                                            ? getTranslated('pending', context)
                                            : status == 'processing' ? getTranslated('pending', context) : status == 'out_for_delivery'
                                        ? getTranslated('processing', context) : getTranslated('DELIVERED', context),
                                    color: Theme.of(context).primaryColor,
                                    isLastItem: true),
                              ],
                            ),
                          ),
                        ],
                      )
                    : status == AppConstants.FAILED ? Center(child: Text('Failed')) : status == AppConstants.RETURNED ? Center(child: Text('Returned'))
                    : Center(child: Text('Invalid order id')) : Center(child: CustomLoader(color: Theme.of(context).primaryColor));
              },
            ),
          ),

          // for footer button
          Container(
            height: 45,
            margin: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            decoration: BoxDecoration(color: ColorResources.getImageBg(context), borderRadius: BorderRadius.circular(6)),
            child: TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => DashBoardScreen()), (route) => false);
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  getTranslated('ORDER_MORE', context),
                  style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.getPrimary(context)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomStepper extends StatelessWidget {
  final String title;
  final Color color;
  final bool isLastItem;
  CustomStepper({@required this.title, @required this.color, this.isLastItem = false});

  @override
  Widget build(BuildContext context) {
    Color myColor;
    if (title == getTranslated('processing', context) || title == getTranslated('pending', context)) {
      myColor = ColorResources.GREY;
    } else {
      myColor = color;
    }
    return Container(
      height: isLastItem ? 50 : 100,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                child: CircleAvatar(backgroundColor: myColor, radius: 10.0),
              ),
              Text(title, style: titilliumRegular)
            ],
          ),
          isLastItem
              ? SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL, left: Dimensions.PADDING_SIZE_LARGE),
                  child: CustomPaint(painter: LineDashedPainter(myColor)),
                ),
        ],
      ),
    );
  }
}
