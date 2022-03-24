

import 'package:flutter/material.dart';
import 'package:bigly24/data/model/body/order_place_model.dart';
import 'package:bigly24/data/model/response/cart_model.dart';

import 'package:bigly24/helper/price_converter.dart';
import 'package:bigly24/localization/language_constrants.dart';
import 'package:bigly24/provider/cart_provider.dart';
import 'package:bigly24/provider/coupon_provider.dart';
import 'package:bigly24/provider/localization_provider.dart';
import 'package:bigly24/provider/order_provider.dart';
import 'package:bigly24/provider/product_provider.dart';
import 'package:bigly24/provider/profile_provider.dart';
import 'package:bigly24/provider/splash_provider.dart';
import 'package:bigly24/utill/color_resources.dart';
import 'package:bigly24/utill/custom_themes.dart';
import 'package:bigly24/utill/dimensions.dart';
import 'package:bigly24/utill/images.dart';
import 'package:bigly24/view/basewidget/amount_widget.dart';
import 'package:bigly24/view/basewidget/animated_custom_dialog.dart';
import 'package:bigly24/view/basewidget/custom_app_bar.dart';
import 'package:bigly24/view/basewidget/my_dialog.dart';
import 'package:bigly24/view/basewidget/title_row.dart';
import 'package:bigly24/view/screen/cart/cart_screen.dart';
import 'package:bigly24/view/screen/checkout/widget/address_bottom_sheet.dart';
import 'package:bigly24/view/screen/checkout/widget/custom_check_box.dart';
import 'package:bigly24/view/screen/dashboard/dashboard_screen.dart';
import 'package:bigly24/view/screen/payment/payment_screen.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cartList;
  final bool fromProductDetails;
  final double totalOrderAmount;
  final double shippingFee;
  final double discount;
  final double tax;
  final int sellerId;
  CheckoutScreen({@required this.cartList, this.fromProductDetails = false, @required this.discount, @required this.tax, @required this.totalOrderAmount, @required this.shippingFee, this.sellerId});


  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _controller = TextEditingController();
  double _order = 0;
  bool _digitalPayment;

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).initAddressList(context);
    Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
    Provider.of<CouponProvider>(context, listen: false).removePrevCouponData();
    // Provider.of<CartProvider>(context, listen: false).getCartDataAPI(context);
    Provider.of<CartProvider>(context, listen: false).getChosenShippingMethod(context);


    _digitalPayment = Provider.of<SplashProvider>(context, listen: false).configModel.digitalPayment;

  }

  @override
  Widget build(BuildContext context) {
    _order = widget.totalOrderAmount+widget.discount;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,

      bottomNavigationBar: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(
          color: ColorResources.getPrimary(context),
          borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
        ),
        child: Consumer<OrderProvider>(
          builder: (context, order, child) {
            // double _shippingCost = Provider.of<CartProvider>(context, listen: false).shippingMethodIndex != null ? Provider.of<CartProvider>(context, listen: false).shippingMethodList[Provider.of<CartProvider>(context, listen: false).shippingMethodIndex[0]].cost : 0;
            // double _couponDiscount = Provider.of<CouponProvider>(context).discount != null ? Provider.of<CouponProvider>(context).discount : 0;
            return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Consumer<CouponProvider>(builder: (context, coupon, child) {
                double _couponDiscount = coupon.discount != null ? coupon.discount : 0;
                return Text(
                  PriceConverter.convertPrice(context, (widget.totalOrderAmount+widget.shippingFee+widget.tax-_couponDiscount)),
                  style: titilliumSemiBold.copyWith(color: Theme.of(context).highlightColor),
                );
              }),
              !Provider.of<OrderProvider>(context).isLoading ? Builder(
                builder: (context) => TextButton(
                  onPressed: () async {
                    if(Provider.of<OrderProvider>(context, listen: false).addressIndex == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(getTranslated('select_a_shipping_address', context)), backgroundColor: Colors.red));
                    }

                    else {
                      List<CartModel> _cartList = [];
                      _cartList.addAll(widget.cartList);

                      for(int index=0; index<widget.cartList.length; index++) {
                        for(int i=0; i<Provider.of<CartProvider>(context, listen: false).chosenShippingList.length; i++) {
                          if(Provider.of<CartProvider>(context, listen: false).chosenShippingList[i].cartGroupId == widget.cartList[index].cartGroupId) {
                            _cartList[index].shippingMethodId = Provider.of<CartProvider>(context, listen: false).chosenShippingList[i].id;
                            break;
                          }
                        }
                      }

                      double couponDiscount = Provider.of<CouponProvider>(context, listen: false).discount != null ? Provider.of<CouponProvider>(context, listen: false).discount : 0;
                      String couponCode = Provider.of<CouponProvider>(context, listen: false).discount != null ? Provider.of<CouponProvider>(context, listen: false).coupon.code : '';
                      if(Provider.of<OrderProvider>(context, listen: false).paymentMethodIndex == 0) {
                        Provider.of<OrderProvider>(context, listen: false).placeOrder(OrderPlaceModel(
                          CustomerInfo(
                            Provider.of<ProfileProvider>(context, listen: false).addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex].id.toString(),
                            Provider.of<ProfileProvider>(context, listen: false).addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex].address,
                          ),
                          _cartList, order.paymentMethodIndex == 0 ? 'cash_on_delivery' : '', couponDiscount,
                        ), _callback, _cartList, Provider.of<ProfileProvider>(context, listen: false).addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex].id.toString(), couponCode);
                      }else {
                        String userID = await Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PaymentScreen(
                          customerID: userID, addressID: Provider.of<ProfileProvider>(context, listen: false).addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex].id.toString(),
                          couponCode: Provider.of<CouponProvider>(context, listen: false).discount != null ? Provider.of<CouponProvider>(context, listen: false).coupon.code : '',
                        )));
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).highlightColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(getTranslated('proceed', context), style: titilliumSemiBold.copyWith(
                    fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                    color: ColorResources.getPrimary(context),
                  )),
                ),
              ) : Container(
                height: 30, width: 100, alignment: Alignment.center,
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).highlightColor)),
              ),
            ]);
          },
        ),
      ),

      body: Column(
        children: [

          CustomAppBar(title: getTranslated('checkout', context)),

          Expanded(
            child: ListView(physics: BouncingScrollPhysics(), padding: EdgeInsets.all(0), children: [

              // Shipping Details
              Container(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(color: Theme.of(context).highlightColor),
                child: Column(children: [
                  InkWell(
                    onTap: () => showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => AddressBottomSheet()),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(getTranslated('SHIPPING_TO', context), style: titilliumRegular),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Text(
                          Provider.of<OrderProvider>(context).addressIndex == null ? getTranslated('add_your_address', context)
                              : Provider.of<ProfileProvider>(context, listen: false).addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex].address,
                          style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Image.asset(Images.EDIT_TWO, width: 15, height: 15, color: ColorResources.getPrimary(context)),
                      ]),
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Divider(height: 2, color: ColorResources.getHint(context)),
                  ),
                  // InkWell(
                  //   onTap: () => showModalBottomSheet(
                  //     context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                  //     builder: (context) => ShippingMethodBottomSheet(),
                  //   ),
                  //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  //     Text(getTranslated('SHIPPING_PARTNER', context), style: titilliumRegular),
                  //     Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  //       Text(
                  //         Provider.of<OrderProvider>(context).shippingIndex == null ? getTranslated('select_shipping_method', context)
                  //             : Provider.of<OrderProvider>(context, listen: false).shippingList[Provider.of<OrderProvider>(context, listen: false).shippingIndex].title,
                  //         style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context)),
                  //         maxLines: 1,
                  //         overflow: TextOverflow.ellipsis,
                  //       ),
                  //       SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  //       Image.asset(Images.EDIT_TWO, width: 15, height: 15, color: ColorResources.getPrimary(context)),
                  //     ]),
                  //   ]),
                  // ),
                ]),
              ),

              // Order Details
              Container(
                margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                color: Theme.of(context).highlightColor,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  TitleRow(title: getTranslated('ORDER_DETAILS', context), onTap: widget.fromProductDetails ? null : () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen(fromCheckout: true,)));
                  }),
                  Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Row(children: [
                      FadeInImage.assetNetwork(
                        placeholder: Images.placeholder, fit: BoxFit.cover, width: 50, height: 50,
                        image: '${Provider.of<CartProvider>(context,listen: false).cartList[0].thumbnail}',
                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, fit: BoxFit.cover, width: 50, height: 50),
                      ),
                      SizedBox(width: Dimensions.MARGIN_SIZE_DEFAULT),
                      Expanded(
                        flex: 3,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            Provider.of<CartProvider>(context,listen: false).cartList[0].name,
                            style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: ColorResources.getPrimary(context)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                          Row(children: [
                            Text(
                              PriceConverter.convertPrice(context, Provider.of<CartProvider>(context,listen: false).cartList[0].price),
                              style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context)),
                            ),
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                            Text("X", style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context))),
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                            Text(Provider.of<CartProvider>(context,listen: false).cartList[0].quantity.toString(), style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context))),
                            // Container(
                            //   height: 20,
                            //   padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            //   margin: EdgeInsets.only(left: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                            //   alignment: Alignment.center,
                            //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: ColorResources.getPrimary(context))),
                            //   child: Text(
                            //     // PriceConverter.percentageCalculation(context, Provider.of<CartProvider>(context,listen: false).cartList[0].price, Provider.of<CartProvider>(context,listen: false).cartList[0].discount, Provider.of<CartProvider>(context,listen: false).cartList[0].discountType),
                            //     PriceConverter.percentageCalculation(context, Provider.of<CartProvider>(context,listen: false).cartList[0].price, Provider.of<CartProvider>(context,listen: false).cartList[0].discount, Provider.of<CartProvider>(context,listen: false).cartList[0].discountType),
                            //     style: titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: ColorResources.getPrimary(context)),
                            //   ),
                            // ),
                          ]),
                        ]),
                      ),
                    ]),
                  ),

                  // Coupon
                  // Row(children: [
                  //   Expanded(
                  //     child: SizedBox(
                  //       height: 40,
                  //       child: TextField(controller: _controller, decoration: InputDecoration(
                  //         hintText: 'Have a coupon?',
                  //         hintStyle: titilliumRegular.copyWith(color: ColorResources.HINT_TEXT_COLOR),
                  //         filled: true,
                  //         fillColor: ColorResources.getIconBg(context),
                  //         border: InputBorder.none,
                  //       )),
                  //     ),
                  //   ),
                  //   SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  //   !Provider.of<CouponProvider>(context).isLoading ? ElevatedButton(
                  //     onPressed: () {
                  //       if(_controller.text.isNotEmpty) {
                  //         Provider.of<CouponProvider>(context, listen: false).initCoupon(_controller.text, _order).then((value) {
                  //           if(value > 0) {
                  //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
                  //             Text('You got ${PriceConverter.convertPrice(context, value)} discount'), backgroundColor: Colors.green));
                  //           }else {
                  //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //               content: Text(getTranslated('invalid_coupon_or', context)),
                  //               backgroundColor: Colors.red,
                  //             ));
                  //           }
                  //         });
                  //       }
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       primary: ColorResources.getGreen(context),
                  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  //     ),
                  //     child: Text(getTranslated('APPLY', context)),
                  //   ) : CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                  // ]),

                ]),
              ),

              // Total bill
              Container(
                margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                color: Theme.of(context).highlightColor,
                child: Consumer<OrderProvider>(
                  builder: (context, order, child) {
                    //_shippingCost = order.shippingIndex != null ? order.shippingList[order.shippingIndex].cost : 0;
                    double _couponDiscount = Provider.of<CouponProvider>(context).discount != null ? Provider.of<CouponProvider>(context).discount : 0;

                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      TitleRow(title: getTranslated('TOTAL', context)),
                      AmountWidget(title: getTranslated('ORDER', context), amount: PriceConverter.convertPrice(context, _order)),
                      // AmountWidget(title: getTranslated('SHIPPING_FEE', context), amount: PriceConverter.convertPrice(context, widget.shippingFee)),
                      // AmountWidget(title: getTranslated('DISCOUNT', context), amount: PriceConverter.convertPrice(context, widget.discount)),
                      // AmountWidget(title: getTranslated('coupon_voucher', context), amount: PriceConverter.convertPrice(context, _couponDiscount)),
                      // AmountWidget(title: getTranslated('TAX', context), amount: PriceConverter.convertPrice(context, widget.tax)),
                      Divider(height: 5, color: Theme.of(context).hintColor),
                      AmountWidget(title: getTranslated('TOTAL_PAYABLE', context), amount: PriceConverter.convertPrice(context, (_order + widget.shippingFee - widget.discount - _couponDiscount + widget.tax))),
                    ]);
                  },
                ),
              ),

              // Payment Method
              // Container(
              //   margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
              //   padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              //   color: Theme.of(context).highlightColor,
              //   child: Column(children: [
              //     TitleRow(title: getTranslated('payment_method', context)),
              //     SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              //     CustomCheckBox(title: getTranslated('cash_on_delivery', context), index: 0),
              //     _digitalPayment != null && _digitalPayment ? CustomCheckBox(title: getTranslated('digital_payment', context), index: 1) : SizedBox(),
              //   ]),
              // ),

            ]),
          ),
        ],
      ),
    );
  }

  void _callback(bool isSuccess, String message, String orderID, List<CartModel> carts) async {
    if(isSuccess) {

      //jaman baba
      // Provider.of<CartProvider>(context, listen: false).removeCheckoutProduct(carts);
      Provider.of<ProductProvider>(context, listen: false).getLatestProductList(
        '1', context, Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode, reload: true,
      );
      if(Provider.of<OrderProvider>(context, listen: false).paymentMethodIndex == 0) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => DashBoardScreen()), (route) => false);
        showAnimatedDialog(context, MyDialog(
          icon: Icons.check,
          title: getTranslated('order_placed', context),
          description: getTranslated('your_order_placed', context),
          isFailed: false,
        ), dismissible: false, isFlip: true);
      }else {

      }
      Provider.of<OrderProvider>(context, listen: false).stopLoader();
    }else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: ColorResources.RED));
    }
  }
}

class PaymentButton extends StatelessWidget {
  final String image;
  final Function onTap;
  PaymentButton({@required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: ColorResources.getGrey(context)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(image),
      ),
    );
  }
}

