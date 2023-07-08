import 'dart:convert';

import 'product_data.dart';

class UserList {
  int id;
  bool isPrivate;
  int userId;
  String name;
  List<SharedWith> usersSharedWith;
  List<Product> items;

  UserList({
    required this.id,
    required this.isPrivate,
    required this.userId,
    required this.name,
    required this.usersSharedWith,
    required this.items,
  });
  String toJson() {
    return jsonEncode(<String, dynamic>{
      'id': id,
      'private': isPrivate,
      'userId': userId,
      'name': name,
      'usersSharedWith':
          usersSharedWith.map((sharedWith) => sharedWith.toJson()).toList(),
      'items': items.map((product) => product.toJson()).toList(),
    });
  }

  factory UserList.fromJson(Map<String, dynamic> json) {
    return UserList(
      id: json['id'],
      isPrivate: json['private'],
      userId: json['userId'],
      name: json['name'],
      usersSharedWith: List<SharedWith>.from(
        json['usersSharedWith'].map(
          (sharedWithJson) => SharedWith.fromJson(sharedWithJson),
        ),
      ),
      items: List<Product>.from(
        json['items'].map(
          (productJson) => Product.fromJson(productJson),
        ),
      ),
    );
  }
  factory UserList.emptyList() {
    return UserList(
        id: 0,
        isPrivate: false,
        userId: 0,
        name: "",
        usersSharedWith: [],
        items: []);
  }
  factory UserList.copy(UserList originalList) {
    return UserList(
      id: originalList.id,
      isPrivate: originalList.isPrivate,
      userId: originalList.userId,
      name: originalList.name,
      usersSharedWith: List<SharedWith>.from(originalList.usersSharedWith),
      items: List<Product>.from(originalList.items),
    );
  }
}

class SharedWith {
  int userId;
  bool canEdit;

  SharedWith({
    required this.userId,
    required this.canEdit,
  });
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'canEdit': canEdit,
    };
  }

  factory SharedWith.fromJson(Map<String, dynamic> json) {
    return SharedWith(
      userId: json['userId'],
      canEdit: json['canEdit'],
    );
  }
}
