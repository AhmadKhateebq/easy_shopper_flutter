import 'package:flutter/material.dart';
import 'package:graduation_project/Pages/customer/googleMap/google_map_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/login.dart';
import '../../Style/borders.dart';

import 'data_container.dart';

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
            onPressed: () {
              return;
              SharedPreferences.getInstance().then((prefs) {
                prefs.setString("userToken", "");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ButtonTheme(
                alignedDropdown: true,
                child: ElevatedButton(
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
                  child: Text('Find Supermarkets'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
