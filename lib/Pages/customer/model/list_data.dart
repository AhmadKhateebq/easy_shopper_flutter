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
      'isPrivate': isPrivate,
      'userId': userId,
      'name': name,
      'usersSharedWith':
          usersSharedWith.map((sharedWith) => sharedWith.toJson()).toList(),
      'items': items.map((product) => product.toJson()).toList(),
    });
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
}
