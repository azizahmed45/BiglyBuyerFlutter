import 'package:flutter/material.dart';
import 'package:bigly24/localization/language_constrants.dart';
import 'package:bigly24/provider/auth_provider.dart';
import 'package:bigly24/provider/splash_provider.dart';
import 'package:bigly24/utill/color_resources.dart';
import 'package:bigly24/utill/dimensions.dart';
import 'package:bigly24/utill/images.dart';
import 'package:bigly24/view/basewidget/button/custom_button.dart';
import 'package:bigly24/view/basewidget/show_custom_snakbar.dart';
import 'package:bigly24/view/screen/auth/auth_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatelessWidget {
  final String tempToken;
  final String mobileNumber;
  final String email;

  VerificationScreen(this.tempToken, this.mobileNumber, this.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: 1170,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 55),
                      Image.asset(
                        Images.login,
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Center(
                            child: Text(
                              email==null?
                              '${getTranslated('please_enter_4_digit_code', context)}\n$mobileNumber':
                              '${getTranslated('please_enter_4_digit_code', context)}\n$email',
                              textAlign: TextAlign.center,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 35),
                        child: PinCodeTextField(
                          length: 4,
                          appContext: context,
                          obscureText: false,
                          showCursor: true,
                          keyboardType: TextInputType.number,
                          animationType: AnimationType.fade,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            fieldHeight: 63,
                            fieldWidth: 55,
                            borderWidth: 1,
                            borderRadius: BorderRadius.circular(10),
                            selectedColor: ColorResources.colorMap[200],
                            selectedFillColor: Colors.white,
                            inactiveFillColor: ColorResources.getSearchBg(context),
                            inactiveColor: ColorResources.colorMap[200],
                            activeColor: ColorResources.colorMap[400],
                            activeFillColor: ColorResources.getSearchBg(context),
                          ),
                          animationDuration: Duration(milliseconds: 300),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          onChanged: authProvider.updateVerificationCode,
                          beforeTextPaste: (text) {
                            return true;
                          },
                        ),
                      ),

                      Center(
                          child: Text(getTranslated('i_didnt_receive_the_code', context),)),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Provider.of<AuthProvider>(context, listen: false).checkPhone(mobileNumber,tempToken).then((value) {
                              if (value.isSuccess) {
                                showCustomSnackBar('Resent code successful', context, isError: false);
                              } else {
                                showCustomSnackBar(value.message, context);
                              }
                            });

                          },
                          child: Padding(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Text(
                              getTranslated('resend_code', context),

                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 48),
                      authProvider.isEnableVerificationCode ? !authProvider.isPhoneNumberVerificationButtonLoading ?
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                        child: CustomButton(
                          buttonText: getTranslated('verify', context),
                          onTap: () {
                            if(Provider.of<SplashProvider>(context,listen: false).configModel.phoneVerification){

                              Provider.of<AuthProvider>(context, listen: false).verifyPhone(mobileNumber,tempToken).then((value) {
                                if(value.isSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(getTranslated('sign_up_successfully_now_login', context)),backgroundColor: Colors.green,)
                                  );
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => AuthScreen(initialPage: 0)), (route) => false);
                                }else {
                                  print(value.message);
                                  showCustomSnackBar(value.message, context);
                                }
                              });
                            }else{
                              Provider.of<AuthProvider>(context, listen: false).verifyEmail(email,tempToken).then((value) {
                                if(value.isSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(getTranslated('sign_up_successfully_now_login', context)),backgroundColor: Colors.green,)
                                  );
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => AuthScreen(initialPage: 0)), (route) => false);
                                }else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(value.message),backgroundColor: Colors.red)
                                  );
                                }
                              });
                            }




                          },
                        ),
                      ):  Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)))
                          : SizedBox.shrink()


                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
