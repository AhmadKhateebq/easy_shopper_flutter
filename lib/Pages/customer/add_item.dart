import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduation_project/Apis/ItemApis.dart';
import 'package:graduation_project/Apis/ListApis.dart';
import 'package:graduation_project/Pages/customer/model/itemModel.dart';
import 'package:graduation_project/Style/borders.dart';

// ignore: must_be_immutable
class AddItem extends StatefulWidget {
  String? listId;
  AddItem(int listId) {
    this.listId = listId.toString();
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddItemState();
  }
}

class AddItemState extends State<AddItem> {
  List<ItemModel> items = List.empty(growable: true);
  bool error = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ItemApis.getAllItems().then((response) {
      try {
        List<dynamic> res = jsonDecode(response.body);
        print("get all items to add : ${res}");
        res.forEach((item) {
          items.add(new ItemModel(
              item['id'] != null ? item['id'] : "",
              item['name'] != null ? item['name'] : "",
              item['brand'] != null ? item['brand'] : "",
              item['category'] != null ? item['category'] : "",
              item['description'] != null ? item['description'] : "",
              item['imageUrl'] != null ? item['imageUrl'] : ""));
        });

        setState(() {});
      } catch (e) {
        print("get all items to add error : ${e}");
        setState(() {
          error = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppBorders.appColor,
        title: Text("Add Item"),
      ),
      body: Align(
        alignment: Alignment.center,
        child: error
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Error Fetching Items ",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.error,
                    size: 22,
                    color: Colors.red,
                  )
                ],
              )
            : items.length == 0
                ? CircularProgressIndicator()
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: ListTile(
                        leading: Text(items[index].id.toString()),
                        title: Text(items[index].name!),
                        subtitle: Text(items[index].description!),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            ListApis.addItemToUserList(
                                    widget.listId!, items[index].id.toString())
                                .then((response) {
                              print(
                                  "add item to user list response : ${response}");
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ));
                    }),
      ),
    );
  }
}
