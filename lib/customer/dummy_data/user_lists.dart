import '../model/list_data.dart';
import '../model/product_data.dart';

List<UserList> userListData = [
  UserList(
    id: 1,
    isPrivate: true,
    userId: 123,
    name: 'List 1',
    usersSharedWith: [
      SharedWith(userId: 456, canEdit: true),
      SharedWith(userId: 789, canEdit: false),
    ],
    items: [
      Product(
        name: 'Product 1',
        brand: 'Brand 1',
        category: 'Category 1',
        description: 'Description 1',
        imageUrl:
            "https://drive.google.com/uc?export=download&id=10wVzpj92cqzacwX9Dl8Kt-OcffZDa1Os",
      ),
      Product(
        name: 'Product 2',
        brand: 'Brand 2',
        category: 'Category 2',
        description: 'Description 2',
        imageUrl:
            "https://drive.google.com/uc?export=download&id=10wVzpj92cqzacwX9Dl8Kt-OcffZDa1Os",
      ),
      Product(
        name: 'Product 3',
        brand: 'Brand 3',
        category: 'Category 3',
        description: 'Description 3',
        imageUrl:
            "https://drive.google.com/uc?export=download&id=10wVzpj92cqzacwX9Dl8Kt-OcffZDa1Os",
      ),
      Product(
        name: 'Product 3',
        brand: 'Brand 3',
        category: 'Category 3',
        description: 'Description 3',
        imageUrl:
            "https://drive.google.com/uc?export=download&id=10wVzpj92cqzacwX9Dl8Kt-OcffZDa1Os",
      ),
      Product(
        name: 'Product 3',
        brand: 'Brand 3',
        category: 'Category 3',
        description: 'Description 3',
        imageUrl:
            "https://drive.google.com/uc?export=download&id=10wVzpj92cqzacwX9Dl8Kt-OcffZDa1Os",
      ),
      Product(
        name: 'Product 3',
        brand: 'Brand 3',
        category: 'Category 3',
        description: 'Description 3',
        imageUrl:
            "https://drive.google.com/uc?export=download&id=10wVzpj92cqzacwX9Dl8Kt-OcffZDa1Os",
      ),
      Product(
        name: 'Product 3',
        brand: 'Brand 3',
        category: 'Category 3',
        description: 'Description 3',
        imageUrl:
            "https://drive.google.com/uc?export=download&id=10wVzpj92cqzacwX9Dl8Kt-OcffZDa1Os",
      ),
      Product(
        name: 'Product 3',
        brand: 'Brand 3',
        category: 'Category 3',
        description: 'Description 3',
        imageUrl:
            "https://drive.google.com/uc?export=download&id=10wVzpj92cqzacwX9Dl8Kt-OcffZDa1Os",
      ),
      Product(
        name: 'Product 3',
        brand: 'Brand 3',
        category: 'Category 3',
        description: 'Description 3',
        imageUrl:
            "https://drive.google.com/uc?export=download&id=10wVzpj92cqzacwX9Dl8Kt-OcffZDa1Os",
      ),
    ],
  ),
  UserList(
    id: 2,
    isPrivate: false,
    userId: 456,
    name: 'List 2',
    usersSharedWith: [
      SharedWith(userId: 123, canEdit: true),
    ],
    items: [
      Product(
        name: 'Product 4',
        brand: 'Brand 4',
        category: 'Category 4',
        description: 'Description 4',
        imageUrl:
            "https://drive.google.com/uc?export=download&id=10wVzpj92cqzacwX9Dl8Kt-OcffZDa1Os",
      ),
      Product(
        name: 'Product 5',
        brand: 'Brand 5',
        category: 'Category 5',
        description: 'Description 5',
        imageUrl:
            "https://drive.google.com/uc?export=download&id=10wVzpj92cqzacwX9Dl8Kt-OcffZDa1Os",
      ),
    ],
  ),
  UserList(
    id: 3,
    isPrivate: true,
    userId: 789,
    name: 'List 3',
    usersSharedWith: [],
    items: [
      Product(
        name: 'Product 6',
        brand: 'Brand 6',
        category: 'Category 6',
        description: 'Description 6',
        imageUrl:
            "https://drive.google.com/uc?export=download&id=10wVzpj92cqzacwX9Dl8Kt-OcffZDa1Os",
      ),
      Product(
        name: 'Product 7',
        brand: 'Brand 7',
        category: 'Category 7',
        description: 'Description 7',
        imageUrl:
            "https://drive.google.com/uc?export=download&id=10wVzpj92cqzacwX9Dl8Kt-OcffZDa1Os",
      ),
      Product(
        name: 'Product 8',
        brand: 'Brand 8',
        category: 'Category 8',
        description: 'Description 8',
        imageUrl:
            "https://drive.google.com/uc?export=download&id=10wVzpj92cqzacwX9Dl8Kt-OcffZDa1Os",
      ),
    ],
  ),
];
