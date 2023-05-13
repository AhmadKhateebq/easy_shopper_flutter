import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduation_project/Apis/LoginApis.dart';
import 'package:graduation_project/Pages/admin/supermarkets/supermarket_page.dart';
import 'package:graduation_project/Pages/admin/users/users_page.dart';
import 'package:graduation_project/Style/borders.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<HomePage> {
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
      var token = value.getString("userToken");
      LoginApis.getAllUsersList(token!).then((resp) {
        print("get all users list: " + "status code ${resp.statusCode}");
        try {
          List<dynamic> list = jsonDecode(resp.body);
          if (!mounted) return;
          setState(() {
            list.forEach((element) {
              print(element);
              userInfo.add([element["userId"], element["name"]]);
            });
          });
        } on Exception catch (e) {
          print("list exception: " + e.toString());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = [
      UsersPage(userInfo),
      SupermarketsPage(),
    ];
    return MaterialApp(
      theme: AppBorders.themeData,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.logout),
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
                  icon: Icon(Icons.shopping_cart_rounded,
                      color: AppBorders.appColor),
                  label: 'Super Markets'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTap,
            selectedItemColor: AppBorders.appColor,
            selectedFontSize: 13.0,
            unselectedFontSize: 13.0,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
