import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduation_project/Apis/supermarketApi.dart';

import '../../../Apis/ItemApis.dart';
import '../../../Style/borders.dart';

// ignore: must_be_immutable
class ChooseItem extends StatefulWidget {
  String? id;
  ChooseItem(String id) {
    this.id = id;
  }
  @override
  State<StatefulWidget> createState() {
    return ChooseItemState();
  }
}

class ChooseItemState extends State<ChooseItem> {
  var items = [];
  bool loading = true, errorLoading = false;
  fetchItems() {
    ItemApis.getAllItems().then((value) {
      String response = value.body;
      int status = value.statusCode;
      print("status: ${status}");
      if (status != 200) {
        setState(() {
          errorLoading = true;
        });
        return;
      }
      try {
        List<dynamic> fetchedList = jsonDecode(response);
        //  print(fetchedList);
        setState(() {
          items = fetchedList;
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
    });
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
          Visibility(
            child: ListTile(
              leading: Icon(
                Icons.error,
                color: Colors.red,
              ),
              title: Text("Error Loading Items"),
            ),
            visible: errorLoading,
          ),
          Container(
              height: screenHeight * 0.8,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ListView.builder(
                /* gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1),*/
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.food_bank),
                      title: Text(items[index]['name']),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (alertContext) {
                                TextEditingController priceController =
                                    new TextEditingController();
                                TextEditingController stockController =
                                    new TextEditingController();
                                return SimpleDialog(
                                  title: Text("${items[index]['name']}"),
                                  children: [
                                    SimpleDialogOption(
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: priceController,
                                        decoration:
                                            AppBorders.txtFieldDecoration(
                                                "Price"),
                                      ),
                                    ),
                                    SimpleDialogOption(
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: stockController,
                                        decoration:
                                            AppBorders.txtFieldDecoration(
                                                "Stock"),
                                      ),
                                    ),
                                    SimpleDialogOption(
                                      child: ElevatedButton.icon(
                                        label: Text("Add Item"),
                                        style: AppBorders.btnStyle(),
                                        onPressed: () {
                                          String price = priceController.text;
                                          String stock = stockController.text;

                                          if (priceController.text.isEmpty ||
                                              stockController.text.isEmpty) {
                                            Navigator.pop(alertContext);
                                            showDialog(
                                                context: context,
                                                builder: (alertContext2) {
                                                  return AlertDialog(
                                                    content: Text(
                                                        "Please fill the price and stock"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                alertContext2);
                                                          },
                                                          child: Text("OK"))
                                                    ],
                                                  );
                                                });

                                            return;
                                          }
                                          SupermarketApis.addItemtoSupermarket(
                                                  price,
                                                  stock,
                                                  widget.id!,
                                                  items[index]['id'].toString())
                                              .then((res) {
                                            Navigator.pop(alertContext);
                                            print(
                                                "resposne : ${res} ${res.statusCode}");
                                            Navigator.pop(context);
                                          });
                                        },
                                        icon: Icon(Icons.add),
                                      ),
                                    )
                                  ],
                                );
                              });
                        },
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
