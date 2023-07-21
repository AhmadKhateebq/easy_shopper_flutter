// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dio/dio.dart';
import '../../Pages/customer/model/product_data.dart';
import '../../api/constant/endpoints.dart';
import '../../api/dio_client.dart';


class ProductApi extends DioClient {
  final DioClient dioClient = DioClient();

  Future<Product> addProductApi(
      String name,String brand, String category, String image,String description) async {
    try {
      final Response response = await dioClient.post(
        Endpoints.products,
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

  Future<List<Product>> getProductsApi() async {
    try {
      final Response response = await dio.get(Endpoints.products);
      final List<dynamic> responseData = response.data;

      final List<Product> products = responseData.map((e) => Product.fromJson(e)).toList();

      return products;
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> updateProductApi(Product product) async {
    try {
      final Response response = await dio.put(
        '${Endpoints.products}/${product.id}',
        data: product.toJson(),
      );
      return Product.fromJson(response.data);
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
