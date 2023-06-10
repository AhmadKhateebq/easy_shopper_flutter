import 'package:flutter/material.dart';
import 'package:graduation_project/customer/dummy_data/product_list.dart';
import 'package:graduation_project/customer/list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'dummy_data/user_lists.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Lists'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: userListData.length,
              itemBuilder: (context, index) {
                final list = userListData[index];
                return ListTile(
                  title: Text(list.name),
                  subtitle:
                      Text('Privacy: ${list.isPrivate ? 'Private' : 'Shared'}'),
                  trailing: Text('Items: ${list.items.length}'),
                  onTap: () {
                    dummyProducts = list.items;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerListPage()),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
