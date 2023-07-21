import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduation_project/Apis/LoginApis.dart';
import 'package:graduation_project/Pages/admin/supermarkets/supermarket_page.dart';
import 'package:graduation_project/Pages/admin/users/users_page.dart';
import 'package:graduation_project/Style/borders.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/login.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppBorders.themeData,
      home: HomeBody(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeBodyState();
  }
}

class HomeBodyState extends State<HomeBody> {
  int _selectedIndex = 0;
  var userInfo = List.empty(growable: true);

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      LoginApis.getUser().then((resp) {
        print("get all users list: " +
            resp.body +
            "status code ${resp.statusCode}");
        try {
          List<dynamic> list = jsonDecode(resp.body);
          if (!mounted) return;
          setState(() {
            list.forEach((element) {
              print(element);
              userInfo.add({
                "id": element["id"],
                "username": element["username"],
                "fname": element["fname"],
                "email": element["email"],
                "lname": element["lname"]
              });
            });
          });
        } on Exception catch (e) {
          print("list exception: " + e.toString());
        }
      });
    });
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = [
      UsersPage(userInfo),
      SupermarketListPage(),
    ];
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    // ignore: unused_local_variable
    double screenHeight = mediaQueryData.size.height;

    return SafeArea(
      child: Scaffold(
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
          title: const Text(
            "Lazy Shopper",
          ),
          backgroundColor: AppBorders.appColor,
          centerTitle: true,
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.supervised_user_circle_rounded,
                  color: AppBorders.appColor,
                ),
                label: "Users"),
            BottomNavigationBarItem(
                icon: Icon(Icons.store, color: AppBorders.appColor),
                label: 'Super Markets'),

          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTap,
          selectedItemColor: AppBorders.appColor,
          selectedFontSize: 13.0,
          unselectedFontSize: 13.0,
        ),
      ),
    );
  }
}
