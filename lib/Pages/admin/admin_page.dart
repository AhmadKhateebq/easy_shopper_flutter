import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graduation_project/Pages/admin/supermarkets/supermarket_page.dart';
import 'package:graduation_project/Pages/admin/users/users_page.dart';
import 'package:graduation_project/Style/borders.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    UsersPage(),
    SupermarketsPage(),
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppBorders.themeData,
      home: SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Lazy Shopper",
          ),
          backgroundColor:  AppBorders.appColor,
          centerTitle: true,
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.supervised_user_circle_rounded,
                  color: AppBorders.appColor,
                ),
                label: "users"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_rounded, color: AppBorders.appColor),
                label: 'supermarkets'),
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
   )
    
    ;
  }
}