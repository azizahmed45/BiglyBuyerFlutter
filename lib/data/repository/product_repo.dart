import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bigly24/data/datasource/remote/dio/dio_client.dart';
import 'package:bigly24/data/datasource/remote/exception/api_error_handler.dart';
import 'package:bigly24/data/model/response/base/api_response.dart';
import 'package:bigly24/helper/product_type.dart';
import 'package:bigly24/utill/app_constants.dart';

class ProductRepo {
  final DioClient dioClient;
  ProductRepo({@required this.dioClient});

  Future<ApiResponse> getLatestProductList(String offset, String languageCode, ProductType productType, String title) async {
    String endUrl;
    // if(productType == ProductType.LATEST_PRODUCT){
    //   endUrl = AppConstants.LATEST_PRODUCTS_URI;
    //   title = 'Latest Product';
    // }
    // else if(productType == ProductType.FEATURED_PRODUCT){
    //   endUrl = AppConstants.FEATURED_PRODUCTS_URI;
    //   title = 'Featured Product';
    // }
     if(productType == ProductType.BEST_SELLING){
      endUrl = AppConstants.BEST_SELLING_PRODUCTS_URI;
      title = 'Best Selling Product';
    }
    else if(productType == ProductType.NEW_ARRIVAL){
      endUrl = AppConstants.NEW_ARRIVAL_PRODUCTS_URI;
      title = 'New Arrival Product';
    }
    else if(productType == ProductType.TOP_PRODUCT){
      endUrl = AppConstants.TOP_PRODUCTS_URI;
      title = 'Top Product';
    }

    try {
      final response = await dioClient.get(
        endUrl+offset,
        options: Options(headers: {AppConstants.LANG_KEY: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  //Seller Products
  Future<ApiResponse> getSellerProductList(String sellerId, String offset, String languageCode) async {
    try {
      final response = await dioClient.get(
        AppConstants.SELLER_PRODUCT_URI+sellerId+'/products?limit=10&&offset='+offset,
        options: Options(headers: {AppConstants.LANG_KEY: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getBrandOrCategoryProductList(bool isBrand, String id, String languageCode) async {
    try {
      String uri;
      if(isBrand){
        uri = '${AppConstants.BRAND_PRODUCT_URI}$id';
      }else {
        uri = '${AppConstants.CATEGORY_PRODUCT_URI}$id';
      }
      final response = await dioClient.get(uri, options: Options(headers: {AppConstants.LANG_KEY: languageCode}));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  Future<ApiResponse> getRelatedProductList(String id, String languageCode) async {
    try {
      final response = await dioClient.get(
        AppConstants.RELATED_PRODUCT_URI+id, options: Options(headers: {AppConstants.LANG_KEY: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> getFeaturedProductList(String offset, String languageCode) async {
    try {
      final response = await dioClient.get(
        AppConstants.FEATURED_PRODUCTS_URI+offset,
        options: Options(headers: {AppConstants.LANG_KEY: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> getLProductList(String offset, String languageCode) async {
    try {
      final response = await dioClient.get(
        AppConstants.LATEST_PRODUCTS_URI+offset,
        options: Options(headers: {AppConstants.LANG_KEY: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}