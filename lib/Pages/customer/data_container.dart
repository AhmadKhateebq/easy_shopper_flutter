import 'dart:convert';

import '../../Apis/supermarketApi.dart';
import '../../Apis/listApis.dart';
import 'dummy_data/product_list.dart';
import 'model/product_data.dart';

List<Product> productList = dummyProducts;
List<Product> doNotContain = dummyProducts.sublist(3, 4);
List<Product> doContain = dummyProducts.sublist(0, 3);
List<Product> getSupermarketItems(_supermarketId) {
  SupermarketApis.getSupermarketItems(_supermarketId).then((resp) {
    print("get supermarket products list: " +
        resp.body +
        "status code ${resp.statusCode}");
    try {
      List<dynamic> responsList = jsonDecode(resp.body);
      List<Product> products = List.empty(growable: true);
      responsList.forEach((element) {
        print(element);
        products.add(_decodeProduct(element));
      });
      return products;
    } on Exception catch (e) {
      print("list exception: " + e.toString());
    }
  });
  return List.empty();
}

List<Product> getListtItems(_listId) {
  ListApis.getListItems(_listId).then((resp) {
    print("get list products list: " +
        resp.body +
        "status code ${resp.statusCode}");
    try {
      List<dynamic> responsList = jsonDecode(resp.body);
      List<Product> products = List.empty(growable: true);
      responsList.forEach((element) {
        print(element);
        products.add(_decodeProduct(element));
      });
      return products;
    } on Exception catch (e) {
      print("list exception: " + e.toString());
    }
  });
  return List.empty();
}

Product _decodeProduct(dynamic element) {
  return Product(
      id: element["id"],
      name: element["name"],
      brand: element["brand"],
      category: element["category"],
      description: element["description"],
      imageUrl: element["iimageUrld"]);
}
