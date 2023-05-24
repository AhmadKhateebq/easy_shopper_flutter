import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduation_project/Apis/ItemApis.dart';
import 'package:graduation_project/Style/borders.dart';

class SuperMarketItems extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SuperMarketItemsState();
  }
}

class _SuperMarketItemsState extends State<SuperMarketItems> {
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
          for (int i = 0; i < items.length; i++)
            Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image(
                        image: NetworkImage(
                            "https://www.eatthis.com/wp-content/uploads/sites/4/2020/07/frito-lay-chips.jpg")),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ))
          /* Container(
            margin: EdgeInsets.all(20),
            child: ElevatedButton.icon(
                style: AppBorders.btnStyle(),
                onPressed: () {},
                icon: Icon(Icons.add_circle),
                label: Text("Add Product")),
          ) */
        ],
      ),
    );
  }
}
