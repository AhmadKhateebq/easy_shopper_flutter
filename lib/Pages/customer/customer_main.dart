import 'package:flutter/material.dart';
import 'package:graduation_project/Style/borders.dart';
import 'package:graduation_project/Pages/customer/list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_container.dart';
import 'model/list_data.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({Key? key}) : super(key: key);

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  late int _userid;
  late Future<List<UserList>> _userListFuture;
  @override
  void initState() {
    super.initState();
    _userid = 0;
    _userListFuture = initializeUser();
  }

  Future<List<UserList>> initializeUser() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.setInt('userId', 4);
    _userid = preferences.getInt('userId')!;
    print(preferences.getInt('userId'));
    return getUserListByUserId(_userid);
  }

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
                Navigator.pushNamed(context, '/add-list');
              },
            ),
          ],
        ),
        body: FutureBuilder<List<UserList>>(
            future: _userListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while waiting for the data
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Handle the error state
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                // Data has been successfully fetched
                List<UserList> userList = snapshot.data!;
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 8.0), // Add vertical spacing
                  child: ListView.builder(
                    //get data from api
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final list = userList[index];
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
                                    builder: (context) =>
                                        CustomerListPage(list.id)),
                              );
                            },
                          ),
                          SizedBox(
                              height:
                                  8.0), // Add vertical spacing between tiles
                        ],
                      );
                    },
                  ),
                );
              }
            }));
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
                    Navigator.pushNamed(context, '/login');
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
