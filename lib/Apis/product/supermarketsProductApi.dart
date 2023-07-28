// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dio/dio.dart';
import '../../Pages/customer/model/product_data.dart';
import '../../api/constant/endpoints.dart';
import '../../api/dio_client.dart';


class SupermarketProductApi extends DioClient {
  final DioClient dioClient = DioClient();

  Future<Product> addProductApi(
      String supermarketId,String id,String name,String brand, String category, String image,String description) async {
    try {
      final Response response = await dioClient.post(
        '${Endpoints.supermarkets}/${supermarketId}${Endpoints.products}/$id',
        data: {
          'name': name,
          'brand':brand,
          'category': category,
          'description':description,
          'imageUrl': image
        },
      );
      return Product.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<supermarketProducts>> getProductsApi(int supermarketId) async {
    try {
      final Response response = await dio.get( '${Endpoints.supermarkets}/${supermarketId}${Endpoints.products}');
      final List<dynamic> responseData = response.data;

      final List<supermarketProducts> products = responseData.map((e) => supermarketProducts.fromJson(e)).toList();

      return products;
    } catch (e) {
      rethrow;
    }
  }


  Future<void> deleteProductApi(int id) async {
    try {
      await dio.delete('${Endpoints.products}/$id');
    } catch (e) {
      rethrow;
    }
  }
}

