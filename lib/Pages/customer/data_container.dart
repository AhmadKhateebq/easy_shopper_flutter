import 'dummy_data/product_list.dart';
import 'model/product_data.dart';

List<Product> productList = dummyProducts;
List<Product> doNotContain = dummyProducts.sublist(3, 4);
List<Product> doContain = dummyProducts.sublist(0, 3);
