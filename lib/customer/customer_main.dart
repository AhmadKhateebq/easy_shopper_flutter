import 'package:flutter/material.dart';
import 'package:graduation_project/Style/borders.dart';
import 'package:graduation_project/customer/list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Pages/login/login.dart';
import 'data_container.dart';
import 'dummy_data/user_lists.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});
  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    // ignore: unused_local_variable
    double screenHeight = mediaQueryData.size.height;
    return Scaffold(
      drawer: Drawer(
        width: screenWidth * 0.45,
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                logout(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.create),
              title: Text(
                "Create Product",
              ),
              onTap: () {},
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('My Lists'),

        backgroundColor: AppBorders.appColor, // Set the background color
        elevation: 10, // Set the elevation (shadow) of the app bar
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.post_add_rounded,
              size: 35,
            ),
            alignment: Alignment.topLeft,
            onPressed: () {
              // Clear token in shared preferences
              SharedPreferences.getInstance()
                  .then((prefs) => prefs.setString("userToken", ""));
              // Redirect user to login page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0), // Add vertical spacing
        child: ListView.builder(
          itemCount: userListData.length,
          itemBuilder: (context, index) {
            final list = userListData[index];
            return Column(
              children: [
                ListTile(
                  title: Text(list.name),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppBorders.appColor,
                    ),
                    child: Icon(
                      Icons.list,
                      color: Color.fromARGB(255, 255, 255, 255),
                      size: 30,
                    ),
                  ),
                  subtitle: Text(
                    'Privacy: ${list.isPrivate ? 'Private' : 'Shared'}',
                  ),
                  trailing: Text('Items: ${list.items.length}'),
                  onTap: () {
                    productList = list.items;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerListPage()),
                    );
                  },
                ),
                SizedBox(height: 8.0), // Add vertical spacing between tiles
              ],
            );
          },
        ),
      ),
    );
  }

  logout(BuildContext context) {
    showDialog(
        context: context,
        builder: (alertContext) {
          return AlertDialog(
            content: Text("Do you want to log out ?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(alertContext).pop();
                    Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => LoginHome()));
                    SharedPreferences.getInstance().then((prefs) {
                      prefs.clear();
                    });
                  },
                  child: Text("Yes")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("No"))
            ],
          );
        });
  }
}
