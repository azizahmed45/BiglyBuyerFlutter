import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bigly24/localization/language_constrants.dart';
import 'package:bigly24/provider/auth_provider.dart';
import 'package:bigly24/provider/profile_provider.dart';
import 'package:bigly24/utill/color_resources.dart';
import 'package:bigly24/view/basewidget/custom_app_bar.dart';
import 'package:bigly24/view/basewidget/no_internet_screen.dart';
import 'package:bigly24/view/basewidget/not_loggedin_widget.dart';
import 'package:bigly24/view/basewidget/show_custom_modal_dialog.dart';
import 'package:bigly24/view/screen/profile/widget/add_address_bottom_sheet.dart';
import 'package:provider/provider.dart';

class AddressListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    bool isGuestMode = !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(!isGuestMode) {
      Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
      Provider.of<ProfileProvider>(context, listen: false).initAddressList(context);
    }

    return Scaffold(
      floatingActionButton: isGuestMode ? null : FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
          builder: (context) => AddAddressBottomSheet(),
        ),
        child: Icon(Icons.add, color: Theme.of(context).highlightColor),
        backgroundColor: ColorResources.getPrimary(context),
      ),
      body: Column(
        children: [

          CustomAppBar(title: getTranslated('ADDRESS_LIST', context)),

          isGuestMode ? Expanded(child: NotLoggedInWidget()) : Consumer<ProfileProvider>(
            builder: (context, profileProvider, child) {
              return profileProvider.addressList != null ? profileProvider.addressList.length > 0 ? Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
                    await Provider.of<ProfileProvider>(context, listen: false).initAddressList(context);
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  child: ListView.builder(
                    padding: EdgeInsets.all(0),
                    itemCount: profileProvider.addressList.length,
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                        title: Text('Address: ${profileProvider.addressList[index].address}' ?? ""),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('City: ${profileProvider.addressList[index].city ?? ""}, Zip: ${profileProvider.addressList[index].zip ?? ""}'),
                            Text('Country: ${profileProvider.addressList[index].country ?? ""}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_forever, color: Colors.red),
                          onPressed: () {
                            showCustomModalDialog(
                              context,
                              title: getTranslated('REMOVE_ADDRESS', context),
                              content: profileProvider.addressList[index].address,
                              cancelButtonText: getTranslated('CANCEL', context),
                              submitButtonText: getTranslated('REMOVE', context),
                              submitOnPressed: () {
                                Provider.of<ProfileProvider>(context, listen: false).removeAddressById(profileProvider.addressList[index].id, index, context);
                                Navigator.of(context).pop();
                              },
                              cancelOnPressed: () => Navigator.of(context).pop(),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ) : Expanded(child: NoInternetOrDataScreen(isNoInternet: false))
                  : Expanded(child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))));
            },
          ),
        ],
      ),
    );
  }


}
