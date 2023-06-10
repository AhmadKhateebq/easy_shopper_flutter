import 'package:flutter/material.dart';
import 'package:graduation_project/Apis/supermarketApi.dart';
import 'package:graduation_project/Style/borders.dart';

class AddSuperMarket extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddSuperMarketState();
  }
}

class _AddSuperMarketState extends State<AddSuperMarket> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _locationX = new TextEditingController();
  TextEditingController _locationY = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "New Super Market",
        ),
        backgroundColor: AppBorders.appColor,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
                controller: _nameController,
                decoration: AppBorders.txtFieldDecoration("Name")),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
                controller: _locationX,
                decoration: AppBorders.txtFieldDecoration("Location X")),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
                controller: _locationY,
                decoration: AppBorders.txtFieldDecoration("Location Y")),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.2, vertical: screenHeight * 0.06),
            child: ElevatedButton.icon(
              onPressed: () {
                String name = _nameController.text,
                    locationX = _locationX.text,
                    locationY = _locationY.text;

                if (name.isEmpty || locationX.isEmpty || locationY.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text("Please fill all the info"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("OK"))
                          ],
                        );
                      });
                  return;
                }
                Navigator.pop(context);

                SupermarketApis.addSupermarket(name, locationX, locationY)
                    .then((response) {
                  print(
                      "add supermarket response: ${response.body} , status: ${response.statusCode}");
                });
              },
              icon: Icon(Icons.assignment),
              label: Text("Submit"),
              style: AppBorders.btnStyle(),
            ),
          )
        ],
      ),
    );
  }
}
