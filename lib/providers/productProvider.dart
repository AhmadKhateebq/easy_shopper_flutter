// ignore_for_file: prefer_final_fields, file_names, avoid_print, non_constant_identifier_names

import 'package:flutter/cupertino.dart';

import '../Apis/product/product_api.dart';
import '../Pages/customer/model/product_data.dart';

class ProductProvider extends ChangeNotifier {
  ProductApi productApi = ProductApi();

  bool isLoading = false;
  List<Product> _products = [];
  List<Product> get products => _products;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> getProducts() async {
    setLoading(true);
    final response = await productApi.getProductsApi();
    print("=====================================");

    _products = response;
    setLoading(false);
  }

  Future<void> AddProduct(
      String name,String brand, double price, String category, String image,String description) async {
    setLoading(true);
    final response =
    await productApi.addProductApi(name, brand,category,image,description);
    print("=====================================");

    print(response.toString());
    setLoading(false);
  }

  Future<void> updateProduct(
      Product product) async {
    setLoading(true);
    final response =
    await productApi.updateProductApi(product);
    print("=====================================");

    print(response.toString());
    setLoading(false);
  }

  Future<void> deleteProduct(int id) async {
    setLoading(true);
    await productApi.deleteProductApi(id);
    print("=====================================");

    setLoading(false);
  }
}
