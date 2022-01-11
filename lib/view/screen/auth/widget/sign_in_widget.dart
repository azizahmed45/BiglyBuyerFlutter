import 'package:bigly24/provider/localization_provider.dart';
import 'package:bigly24/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:bigly24/data/model/body/login_model.dart';
import 'package:bigly24/localization/language_constrants.dart';
import 'package:bigly24/provider/auth_provider.dart';
import 'package:bigly24/provider/cart_provider.dart';
import 'package:bigly24/provider/profile_provider.dart';
import 'package:bigly24/utill/color_resources.dart';
import 'package:bigly24/utill/custom_themes.dart';
import 'package:bigly24/utill/dimensions.dart';
import 'package:bigly24/view/basewidget/button/custom_button.dart';
import 'package:bigly24/view/basewidget/textfield/custom_password_textfield.dart';
import 'package:bigly24/view/basewidget/textfield/custom_textfield.dart';
import 'package:bigly24/view/screen/auth/forget_password_screen.dart';
import 'package:bigly24/view/screen/auth/widget/social_login_widget.dart';
import 'package:bigly24/view/screen/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';

class SignInWidget extends StatefulWidget {
  @override
  _SignInWidgetState createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  GlobalKey<FormState> _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailController.text = Provider.of<AuthProvider>(context, listen: false).getUserEmail() ?? null;
    _passwordController.text = Provider.of<AuthProvider>(context, listen: false).getUserPassword() ?? null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  FocusNode _emailNode = FocusNode();
  FocusNode _passNode = FocusNode();
  LoginModel loginBody = LoginModel();

  void loginUser() async {
    if (_formKeyLogin.currentState.validate()) {
      _formKeyLogin.currentState.save();

      String _email = _emailController.text.trim();
      String _password = _passwordController.text.trim();

      if (_email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('EMAIL_MUST_BE_REQUIRED', context)),
          backgroundColor: Colors.red,
        ));
      } else if (_password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('PASSWORD_MUST_BE_REQUIRED', context)),
          backgroundColor: Colors.red,
        ));
      } else {

        if (Provider.of<AuthProvider>(context, listen: false).isRemember) {
          Provider.of<AuthProvider>(context, listen: false).saveUserEmail(_email, _password);
        } else {
          Provider.of<AuthProvider>(context, listen: false).clearUserEmailAndPassword();
        }

        loginBody.email = _email;
        loginBody.password = _password;
        await Provider.of<AuthProvider>(context, listen: false).login(loginBody, route);
      }
    }
  }

  route(bool isRoute, String errorMessage) async {
    if (isRoute) {
      String _languageCode = Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode;
      await Provider.of<ProductProvider>(context, listen: false).getLatestProductList('1', context, _languageCode, reload: true);

      await Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DashBoardScreen()), (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).isRemember;

    return Form(
      key: _formKeyLogin,
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
        children: [
          // for Email
          Container(
              margin:
              EdgeInsets.only(left: Dimensions.MARGIN_SIZE_LARGE, right: Dimensions.MARGIN_SIZE_LARGE, bottom: Dimensions.MARGIN_SIZE_SMALL),
              child: CustomTextField(
                hintText: getTranslated('ENTER_YOUR_EMAIL', context),
                focusNode: _emailNode,
                nextNode: _passNode,
                textInputType: TextInputType.emailAddress,
                controller: _emailController,
              )),

          // for Password
          Container(
              margin:
              EdgeInsets.only(left: Dimensions.MARGIN_SIZE_LARGE, right: Dimensions.MARGIN_SIZE_LARGE, bottom: Dimensions.MARGIN_SIZE_DEFAULT),
              child: CustomPasswordTextField(
                hintTxt: getTranslated('ENTER_YOUR_PASSWORD', context),
                textInputAction: TextInputAction.done,
                focusNode: _passNode,
                controller: _passwordController,
              )),

          // for remember and forgetpassword
          Container(
            margin: EdgeInsets.only(left: Dimensions.MARGIN_SIZE_SMALL, right: Dimensions.MARGIN_SIZE_SMALL),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) => Checkbox(
                        checkColor: ColorResources.WHITE,
                        activeColor: Theme.of(context).primaryColor,
                        value: authProvider.isRemember,
                        onChanged: authProvider.updateRemember,
                      ),
                    ),
                    //

                    Text(getTranslated('REMEMBER', context), style: titilliumRegular),
                  ],
                ),
                InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ForgetPasswordScreen())),
                  child: Text(getTranslated('FORGET_PASSWORD', context), style: titilliumRegular.copyWith(color: ColorResources.getLightSkyBlue(context))),
                ),
              ],
            ),
          ),

          // for signin button
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
            child: Provider.of<AuthProvider>(context).isLoading
                ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            )
                : CustomButton(onTap: loginUser, buttonText: getTranslated('SIGN_IN', context)),
          ),

          SizedBox(width: 25),

          // SocialLoginWidget(),

          SizedBox(height: 20),
          Center(child: Text(getTranslated('OR', context), style: titilliumRegular.copyWith(fontSize: 12))),

          //for order as guest
          GestureDetector(
            onTap: () {
              if (!Provider.of<AuthProvider>(context, listen: false).isLoading) {
                Provider.of<CartProvider>(context, listen: false).getCartData();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DashBoardScreen()), (route) => false);
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 50, right: 50, top: 30),
              width: double.infinity,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: ColorResources.getHint(context), width: 1.0),
              ),
              child: Text(getTranslated('CONTINUE_AS_GUEST', context), style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context))),
            ),
          ),
        ],
      ),
    );
    //   Consumer<GoogleSignInProvider>(builder: (ctx,model,child){
    //   if(model.googleAccount != null){
    //     return googleLoggedInUI(model);
    //   }else{
    //     return loginControls(context);
    //   }
    //
    // });

  }

   // googleLoggedInUI(GoogleSignInProvider model) {
   //  return  Form(
   //    child: ListView(
   //      children: [
   //        Container(
   //            margin:
   //            EdgeInsets.only(left: Dimensions.MARGIN_SIZE_LARGE, right: Dimensions.MARGIN_SIZE_LARGE, bottom: Dimensions.MARGIN_SIZE_SMALL),
   //            child: TextFormField(
   //              focusNode: _emailNode,
   //              initialValue: model.googleAccount.displayName,
   //              controller: _emailController,
   //            )),
   //
   //        Container(
   //            margin:
   //            EdgeInsets.only(left: Dimensions.MARGIN_SIZE_LARGE, right: Dimensions.MARGIN_SIZE_LARGE, bottom: Dimensions.MARGIN_SIZE_SMALL),
   //            child: TextFormField(
   //              focusNode: _emailNode,
   //              initialValue: model.googleAccount.email,
   //              controller: _emailController,
   //            )),
   //
   //      ],
   //    ),
   //  );
   // }
   //
   // loginControls(BuildContext context) {
   //   return Form(
   //     key: _formKeyLogin,
   //     child: ListView(
   //       padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
   //       children: [
   //         // for Email
   //         Container(
   //             margin:
   //                 EdgeInsets.only(left: Dimensions.MARGIN_SIZE_LARGE, right: Dimensions.MARGIN_SIZE_LARGE, bottom: Dimensions.MARGIN_SIZE_SMALL),
   //             child: CustomTextField(
   //               hintText: getTranslated('ENTER_YOUR_EMAIL', context),
   //               focusNode: _emailNode,
   //               nextNode: _passNode,
   //               textInputType: TextInputType.emailAddress,
   //               controller: _emailController,
   //             )),
   //
   //         // for Password
   //         Container(
   //             margin:
   //                 EdgeInsets.only(left: Dimensions.MARGIN_SIZE_LARGE, right: Dimensions.MARGIN_SIZE_LARGE, bottom: Dimensions.MARGIN_SIZE_DEFAULT),
   //             child: CustomPasswordTextField(
   //               hintTxt: getTranslated('ENTER_YOUR_PASSWORD', context),
   //               textInputAction: TextInputAction.done,
   //               focusNode: _passNode,
   //               controller: _passwordController,
   //             )),
   //
   //         // for remember and forgetpassword
   //         Container(
   //           margin: EdgeInsets.only(left: Dimensions.MARGIN_SIZE_SMALL, right: Dimensions.MARGIN_SIZE_SMALL),
   //           child: Row(
   //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
   //             children: [
   //               Row(
   //                 children: [
   //                   Consumer<AuthProvider>(
   //                     builder: (context, authProvider, child) => Checkbox(
   //                       checkColor: ColorResources.WHITE,
   //                       activeColor: Theme.of(context).primaryColor,
   //                       value: authProvider.isRemember,
   //                       onChanged: authProvider.updateRemember,
   //                     ),
   //                   ),
   //                   //
   //
   //                   Text(getTranslated('REMEMBER', context), style: titilliumRegular),
   //                 ],
   //               ),
   //               InkWell(
   //                 onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ForgetPasswordScreen())),
   //                 child: Text(getTranslated('FORGET_PASSWORD', context), style: titilliumRegular.copyWith(color: ColorResources.getLightSkyBlue(context))),
   //               ),
   //             ],
   //           ),
   //         ),
   //
   //         // for signin button
   //         Container(
   //           margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
   //           child: Provider.of<AuthProvider>(context).isLoading
   //               ? Center(
   //                   child: CircularProgressIndicator(
   //                     valueColor: new AlwaysStoppedAnimation<Color>(
   //                       Theme.of(context).primaryColor,
   //                     ),
   //                   ),
   //                 )
   //               : CustomButton(onTap: loginUser, buttonText: getTranslated('SIGN_IN', context)),
   //         ),
   //
   //         SizedBox(width: 25),
   //         Column(
   //           mainAxisAlignment: MainAxisAlignment.center,
   //           children: [
   //             InkWell(
   //               onTap: () {
   //                 Provider.of<GoogleSignInProvider>(context, listen: false).login();
   //               },
   //               child: Ink(
   //                 color: Color(0xFF397AF3),
   //                 child: Padding(
   //                   padding: EdgeInsets.all(6),
   //                   child: Card(
   //                     color: Color(0xFF397AF3),
   //                     child: Padding(
   //                       padding: const EdgeInsets.all(2.0),
   //                       child: Wrap(
   //                         crossAxisAlignment: WrapCrossAlignment.center,
   //                         children: [
   //                           Container(
   //                             decoration: BoxDecoration(
   //                                 color: Colors.white ,
   //                               borderRadius: BorderRadius.all(Radius.circular(5))
   //                             ),
   //                               height: 30,width: 30,
   //                               child: Padding(
   //                                 padding: const EdgeInsets.all(4.0),
   //                                 child: Image.asset(Images.google),
   //                               )), // <-- Use 'Image.asset(...)' here
   //                           SizedBox(width: 12),
   //                           Padding(
   //                             padding: const EdgeInsets.fromLTRB(0,8,8,8),
   //                             child: Text('Sign in with Google',maxLines: 2, style: TextStyle(color: Colors.white),),
   //                           ),
   //                         ],
   //                       ),
   //                     ),
   //                   ),
   //                 ),
   //               ),
   //             ),
   //
   //             InkWell(
   //               onTap: () {Provider.of<FacebookLoginProvider>(context, listen: false).login();},
   //               child: Ink(
   //                 color: Color(0xFF397AF3),
   //                 child: Padding(
   //                   padding: EdgeInsets.all(6),
   //                   child: Card(
   //                     child: Padding(
   //                       padding: const EdgeInsets.all(8.0),
   //                       child: Wrap(
   //                         crossAxisAlignment: WrapCrossAlignment.center,
   //                         children: [
   //                           Container(height: 30,width: 30,
   //                               child: Image.asset(Images.facebook)), // <-- Use 'Image.asset(...)' here
   //                           SizedBox(width: 8),
   //                           Text('Sign in with Facebook',maxLines: 2,),
   //                         ],
   //                       ),
   //                     ),
   //                   ),
   //                 ),
   //               ),
   //             ),
   //
   //
   //           ],
   //         ),
   //
   //         SizedBox(height: 20),
   //         Center(child: Text(getTranslated('OR', context), style: titilliumRegular.copyWith(fontSize: 12))),
   //
   //         //for order as guest
   //         GestureDetector(
   //           onTap: () {
   //             if (!Provider.of<AuthProvider>(context, listen: false).isLoading) {
   //               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => DashBoardScreen()), (route) => false);
   //             }
   //           },
   //           child: Container(
   //             margin: EdgeInsets.only(left: 50, right: 50, top: 30),
   //             width: double.infinity,
   //             height: 40,
   //             alignment: Alignment.center,
   //             decoration: BoxDecoration(
   //               color: Colors.transparent,
   //               borderRadius: BorderRadius.circular(6),
   //               border: Border.all(color: ColorResources.getHint(context), width: 1.0),
   //             ),
   //             child: Text(getTranslated('CONTINUE_AS_GUEST', context), style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context))),
   //           ),
   //         ),
   //       ],
   //     ),
   //   );
   // }
}
