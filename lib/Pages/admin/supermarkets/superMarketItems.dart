import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduation_project/Apis/ItemApis.dart';
import 'package:graduation_project/Pages/admin/supermarkets/chooseItem.dart';
import 'package:graduation_project/Style/borders.dart';

class SuperMarketItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Supermarket Items"),
        backgroundColor: AppBorders.appColor,
        centerTitle: true,
      ),
      body: SuperMarketItemsBody(),
    );
  }
}

class SuperMarketItemsBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SuperMarketItemsBodyState();
  }
}

class SuperMarketItemsBodyState extends State<SuperMarketItemsBody> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    double screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;

    return ListView(
      children: [
        Container(
          width: screenWidth * 0.6,
          margin: EdgeInsets.all(20),
          child: ElevatedButton.icon(
              style: AppBorders.btnStyle(),
              onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) {
                  return ChooseItem();
                }));
              },
              icon: Icon(Icons.list),
              label: Text("Add Item From List")),
        )
      ],
    );
  }
}
