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
}

class SharedWith {
  int userId;
  bool canEdit;

  SharedWith({
    required this.userId,
    required this.canEdit,
  });
}
