import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graduation_project/Style/borders.dart';

class ListSettings extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ListSettingsState();
  }
}

class ListSettingsState extends State<ListSettings> {
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("List Settings"),
      backgroundColor: AppBorders.appColor,

      ),
      body: SingleChildScrollView(child: Column(children: [

      ]),),
    );
  }
}
