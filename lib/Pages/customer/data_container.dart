import 'dart:convert';

import 'package:graduation_project/Pages/customer/model/list_data.dart';

import '../../Apis/supermarketApi.dart';
import '../../Apis/listApis.dart';
import 'model/product_data.dart';

List<Product> productList = [];
List<Product> doNotContain = [];
List<Product> doContain = [];
Future<List<Product>> getSupermarketItems(_supermarketId) async {
  await SupermarketApis.getSupermarketItems(_supermarketId).then((resp) {
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

Future<List<Product>> getListItems(int? listId) async {
  if (listId == null) {
    return [];
  }

  final resp = await ListApis.getListItems(listId.toString());
  print("get list products list: " +
      resp.body +
      " status code ${resp.statusCode}");

  try {
    dynamic responseBody = jsonDecode(resp.body);
    if (responseBody is List) {
      List<Product> products = responseBody.map((element) {
        print("list product : ${element}");
        return _decodeProduct(element);
      }).toList();

      return products;
    } else if (responseBody is Map) {
      Product product = _decodeProduct(responseBody);
      return [product];
    } else {
      throw Exception("Invalid response body format");
    }
  } catch (e) {
    print("list exception: " + e.toString());
    return [];
  }
}

Future<List<UserList>> getUserListByUserId(int _userId) async {
  final resp = await ListApis.getListByUserId(_userId.toString());
  print("get lists list: " + resp.body + " status code ${resp.statusCode}");

  try {
    List<dynamic> responseList = jsonDecode(resp.body);
    List<UserList> products = [];

    responseList.forEach((element) {
      print(element);
      products.add(_decodeList(element));
    });

    return products;
  } catch (e) {
    print("list exception: " + e.toString());
    return [];
  }
}

Future<List<UserList>> getListsSharedWithUser(int _userId) async {
  final resp = await ListApis.getListSharedWithUser(_userId.toString());
  print("get lists list: " + resp.body + " status code ${resp.statusCode}");

  try {
    List<dynamic> responseList = jsonDecode(resp.body);
    List<UserList> products = [];

    responseList.forEach((element) {
      print(element);
      products.add(_decodeList(element));
    });

    return products;
  } catch (e) {
    print("list exception: " + e.toString());
    return [];
  }
}

// getListByUserId
Product _decodeProduct(dynamic element) {
  int itemId = element['id'];
  String itemName = element['name'];
  String itemBrand = element['brand'];
  String itemCategory = element['category'];
  String itemDescription = element['description'];
  String itemImageUrl = element['imageUrl'];
  return Product(
    id: itemId,
    name: itemName,
    brand: itemBrand,
    category: itemCategory,
    description: itemDescription,
    imageUrl: itemImageUrl,
  );
}

UserList _decodeList(dynamic element) {
  int id = element['id'];
  bool isPrivate = element['private'];
  int userId = element['userId'];
  String name = element['name'];

  // Decoding usersSharedWith
  List<SharedWith> sharedWith = [];
  List<dynamic> sharedWithList = element['usersSharedWith'];
  sharedWithList.forEach((sharedWithElement) {
    int sharedUserId = sharedWithElement['userId'];
    bool canEdit = sharedWithElement['canEdit'];
    SharedWith sharedWithUser =
        SharedWith(userId: sharedUserId, canEdit: canEdit);
    sharedWith.add(sharedWithUser);
  });

  // Decoding items
  List<Product> items = [];
  List<dynamic> itemsList = element['items'];
  itemsList.forEach((itemElement) {
    Product item = _decodeProduct(itemElement);
    items.add(item);
  });

  return UserList(
    id: id,
    isPrivate: isPrivate,
    userId: userId,
    name: name,
    usersSharedWith: sharedWith,
    items: items,
  );
}
