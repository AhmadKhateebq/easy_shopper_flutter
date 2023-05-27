import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../Apis/ItemApis.dart';
import '../../../Style/borders.dart';

class ChooseItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
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
    // TODO: implement initState
    super.initState();
    fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Super Market Items"),
        backgroundColor: AppBorders.appColor,
        centerTitle: true,
      ),
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
                              builder: (context) {
                                TextEditingController price = new TextEditingController();
                                TextEditingController stock = new TextEditingController();
                                return SimpleDialog(
                                  title: Text("Add ${items[index]['name']}"),
                                  children: [

                                    SimpleDialogOption(
                                      child: TextFormField(
                                        decoration:
                                        AppBorders.txtFieldDecoration("Price")
                                      ,
                                      ),)
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
