import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduation_project/Apis/supermarketApi.dart';
import 'package:graduation_project/Pages/admin/supermarkets/chooseItem.dart';
import 'package:graduation_project/Style/borders.dart';

String? supID, supName;

class SuperMarketItems extends StatelessWidget {
  SuperMarketItems(name, id) {
    supID = id;
    supName = name;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${supName} Items"),
        backgroundColor: AppBorders.appColor,
        centerTitle: true,
      ),
      body: SuperMarketItemsBody(supID),
    );
  }
}

// ignore: must_be_immutable
class SuperMarketItemsBody extends StatefulWidget {
  String? supID;
  SuperMarketItemsBody(id) {
    this.supID = id;
  }
  @override
  State<StatefulWidget> createState() {
    return SuperMarketItemsBodyState();
  }
}

class SuperMarketItemsBodyState extends State<SuperMarketItemsBody> {
  bool error = false;
  List<dynamic> items = [];
  fetchItems() {
    SupermarketApis.getSupermarketItems(widget.supID!).then((res) {
      String response = res.body;
      print(
          "supermarket items response : ${response} status ${res.statusCode}");
      try {
        List<dynamic> jsonResponse = jsonDecode(response);
        var temp = [];
        jsonResponse.forEach((element) {
          temp.add(element);
        });
        setState(() {
          items = temp;
        });
      } catch (e) {
        print("error fetch items ${e}");
        setState(() {
          error = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width,
        // ignore: unused_local_variable
        screenHeight = MediaQuery.of(context).size.height;

    return ListView(
      children: [
        for (int index = 0; index < items.length; index++)
          Card(
            child: ListTile(
              leading: Icon(Icons.food_bank),
              title: Text(items[index]['product']['name'].toString()),
              subtitle: Text("${items[index]['price'].toString()} NIS"),
              trailing: IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () {
                  SupermarketApis.removeProduct(
                          supID!, items[index]['product']['id'].toString())
                      .then((res) {
                    print(
                        "remove product response : ${res} status : ${res.statusCode}");
                    if (res.statusCode == 200 || res.statusCode == 204) {
                      fetchItems();
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("Erorr Deleting item"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK"))
                              ],
                            );
                          });
                    }
                  });
                },
              ),
            ),
          ),
        Visibility(
          child: ListTile(
            leading: Icon(
              Icons.error,
              color: Colors.red,
            ),
            title: Text("Error fetching items"),
          ),
          visible: error,
        ),
        Container(
          width: screenWidth * 0.6,
          margin: EdgeInsets.all(20),
          child: ElevatedButton.icon(
              style: AppBorders.btnStyle(),
              onPressed: () async {
                await Navigator.push(context,
                    new MaterialPageRoute(builder: (context) {
                  return ChooseItem(widget.supID!);
                }));

                fetchItems();
              },
              icon: Icon(Icons.list),
              label: Text("Add Item From List")),
        )
      ],
    );
  }
}
