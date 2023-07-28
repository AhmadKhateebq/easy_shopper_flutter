import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../Apis/ItemApis.dart';
import '../../../Apis/product/supermarketsProductApi.dart';
import '../../../Apis/supermarketApi.dart';
import '../../../Style/borders.dart';
import '../../customer/model/product_data.dart';

class SupermarketProductPage extends StatefulWidget {
  const SupermarketProductPage({super.key, required this.id});
  final int id ;

  @override
  State<SupermarketProductPage> createState() => _SupermarketProductPageState();
}

class _SupermarketProductPageState extends State<SupermarketProductPage> {
  List<supermarketProducts> items = [];
  bool loading = true, errorLoading = false;

  fetchItems() async {
    SupermarketProductApi supermarketProductApi = SupermarketProductApi() ;

     List<supermarketProducts> products = await supermarketProductApi.getProductsApi(widget.id) ;
        setState(() {
          errorLoading = true;
        });

      try {

        //  print(fetchedList);
        setState(() {
          items = products;
          items.forEach((element) {
            print(element);
          });
        });
      } catch (e) {
        print("fetch items exception e : ${e}");
        setState(() {
          errorLoading = true;
        });
      }

  }

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(

      body: ListView(
        children: [

          Container(
              height: screenHeight * 0.8,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.food_bank),
                      title: Text(items[index].product.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Stock: ${items[index].stock}'),
                          Text('Price: \$${items[index].price.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  );
                },
              ))
        ],
      ),
    );
  }
}
