import 'package:flutter/material.dart';
import 'package:graduation_project/Style/borders.dart';

class SuperMarketItems extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SuperMarketItemsState();
  }
}

class _SuperMarketItemsState extends State<SuperMarketItems> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Super Market Items"),
        backgroundColor: AppBorders.appColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            margin: EdgeInsets.all(20),
            child: ElevatedButton.icon(
                style: AppBorders.btnStyle(),
                onPressed: () {},
                icon: Icon(Icons.add_circle),
                label: Text("Add Product")),
          )
        ]),
      ),
    );
  }
}
