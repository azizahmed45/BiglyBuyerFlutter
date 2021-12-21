import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bigly24/data/datasource/remote/dio/dio_client.dart';
import 'package:bigly24/data/datasource/remote/exception/api_error_handler.dart';
import 'package:bigly24/data/model/response/base/api_response.dart';
import 'package:bigly24/utill/app_constants.dart';

class FlashDealRepo {
  final DioClient dioClient;
  FlashDealRepo({@required this.dioClient});

  Future<ApiResponse> getFlashDeal(String languageCode) async {
    try {
      final response = await dioClient.get(AppConstants.FLASH_DEAL_URI,
        options: Options(headers: {AppConstants.LANG_KEY: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getFlashDealList(String productID, String languageCode) async {
    try {
      final response = await dioClient.get('${AppConstants.FLASH_DEAL_PRODUCT_URI}$productID',
        options: Options(headers: {AppConstants.LANG_KEY: languageCode}),
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}