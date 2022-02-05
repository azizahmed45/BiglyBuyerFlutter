import 'package:flutter/material.dart';
import 'package:bigly24/data/model/response/banner_model.dart';
import 'package:bigly24/data/model/response/base/api_response.dart';
import 'package:bigly24/data/repository/banner_repo.dart';
import 'package:bigly24/helper/api_checker.dart';

class BannerProvider extends ChangeNotifier {
  final BannerRepo bannerRepo;

  BannerProvider({@required this.bannerRepo});

  List<BannerModel> _mainBannerList;
  List<BannerModel> _footerBannerList;
  int _currentIndex;

  List<BannerModel> get mainBannerList => _mainBannerList;
  List<BannerModel> get footerBannerList => _footerBannerList;
  int get currentIndex => _currentIndex;

  void initBanner() {
    BannerModel banner1 = BannerModel(
        photo:
            "https://bigly24.com/_next/image?url=%2Fstatic%2Fimg%2Fslider%2Fslider.jpg&w=1080&q=75");

    BannerModel banner2 = BannerModel(
        photo:
            "https://bigly24.com/_next/image?url=%2Fstatic%2Fimg%2Fslider%2Fslider.jpg&w=1080&q=75");

    _mainBannerList = [];
    _mainBannerList.add(banner1);
    _mainBannerList.add(banner2);
    _currentIndex = 0;
    notifyListeners();
  }

  Future<void> getBannerList(bool reload, BuildContext context) async {
    if (_mainBannerList == null || reload) {
      ApiResponse apiResponse = await bannerRepo.getBannerList();
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        _mainBannerList = [];
        apiResponse.response.data.forEach((bannerModel) =>
            _mainBannerList.add(BannerModel.fromJson(bannerModel)));
        _currentIndex = 0;
        notifyListeners();
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }
    }
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> getFooterBannerList(BuildContext context) async {
    ApiResponse apiResponse = await bannerRepo.getFooterBannerList();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _footerBannerList = [];
      apiResponse.response.data.forEach((bannerModel) =>
          _footerBannerList.add(BannerModel.fromJson(bannerModel)));
      notifyListeners();
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
  }
}
