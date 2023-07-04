import 'package:flutter/material.dart';
import 'package:graduation_project/Apis/ListApis.dart';
import 'package:graduation_project/Pages/customer/add_item.dart';
import 'package:graduation_project/Pages/customer/googleMap/google_map_page.dart';
import 'package:graduation_project/Pages/customer/model/product_data.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../login/login.dart';
import '../../Style/borders.dart';

import 'data_container.dart';
import 'googleMap/google_map_page.dart';

// ignore: must_be_immutable
class CustomerListPage extends StatefulWidget {
  int? listId;
  CustomerListPage(int _listId) {
    this.listId = _listId;
  }

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  List<Product> productList = List.empty(growable: true);
  void loadList() {
    getListItems(widget.listId).then((response) {
      setState(() {
        productList = response;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My List'),
        backgroundColor: AppBorders.appColor,
        elevation: 10,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30,
            ),
            alignment: Alignment.topLeft,
            onPressed: () async {
              await Navigator.push(context,
                  new MaterialPageRoute(builder: (context) {
                return AddItem(widget.listId!);
              }));
              loadList();
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  children: productList.map((product) {
                    return Card(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(product.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.0),
                                Text(product.category),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton.icon(
                                        onPressed: () {
                                          ListApis.removeItemFromUserList(
                                                  widget.listId.toString(),
                                                  product.id.toString())
                                              .then((delResponse) {
                                            print(
                                                "remove item from user list : ${delResponse.body}");
                                            loadList();
                                          });
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: AppBorders.appColor,
                                        ),
                                        label: Text(
                                          "Delete Item",
                                          style: TextStyle(
                                              color: AppBorders.appColor),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(bottom: 50),
                  width: 250,
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        var prefs = await SharedPreferences.getInstance();
                        prefs.setInt("listId", widget.listId!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GoogleMapHomePage()),
                        );
                      },
                      style: AppBorders.btnStyle(),
                      label: Text(
                        'Find Supermarkets',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ))
          ],
        ),
        margin: EdgeInsets.only(top: 10),
      )),
    );
  }
}
