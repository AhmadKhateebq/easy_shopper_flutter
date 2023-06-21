import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Pages/customer/data_container.dart';
import '../Pages/customer/google_map_page.dart';
import '../Pages/login/login.dart';
import '../Style/borders.dart';


class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

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
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.02,
              left: MediaQuery.of(context).size.width * 0.25,
              right: MediaQuery.of(context).size.width * 0.25,
              child: ButtonTheme(
                alignedDropdown: true,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GoogleMapPage()),
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
