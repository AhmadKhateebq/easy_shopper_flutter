import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:graduation_project/Style/borders.dart';
import 'package:graduation_project/Pages/customer/list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Apis/ListApis.dart';
import 'create_list.dart';
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateListScreen(),
                    ));
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
              } else if (!snapshot.hasData) {
                // Handle the case where there is no data available
                return Center(child: Text('No data available'));
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
                          Slidable(
                            startActionPane: ActionPane(
                              extentRatio: 0.3,
                              motion: const BehindMotion(),
                              children: [
                                SlidableAction(
                                  backgroundColor: Colors.red,
                                  icon: Icons.delete,
                                  label: 'delete',
                                  onPressed: (context) =>
                                      deleteList(context, list.id),
                                )
                              ],
                            ),
                            endActionPane: ActionPane(
                              extentRatio: 0.3,
                              motion: const BehindMotion(),
                              children: [
                                SlidableAction(
                                  backgroundColor:
                                      const Color.fromARGB(255, 89, 83, 83),
                                  icon: Icons.settings,
                                  label: 'Settings',
                                  onPressed: (context) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomerListPage(list.id)),
                                  ),
                                )
                              ],
                            ),
                            child: buildListListTile(list),
                            // SizedBox(
                            //     height:
                            //         8.0),
                          )
                          // Add vertical spacing between tiles
                        ],
                      );
                    },
                  ),
                );
              }
            }));
  }

  Widget buildListListTile(UserList list) => ListTile(
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
            MaterialPageRoute(builder: (context) => CustomerListPage(list.id)),
          );
        },
      );

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

  deleteList(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (alertContext) {
        return Builder(
          builder: (context) {
            return AlertDialog(
              content: Text("Do you want to delete this list?"),
              actions: [
                TextButton(
                  onPressed: () async {
                    await _deleteOnAction(id, context);
                    Navigator.pop(context);

                    // Fetch user lists again to update the UI
                    _userListFuture = initializeUser();
                    setState(() {});
                  },
                  child: Text("Yes"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("No"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _deleteOnAction(int id, BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userId = preferences.getInt('userId');
    if (userId == null) {
      return;
    }
    print(id);
    http.Response response = await ListApis.removeList(id, userId);
    if (response.statusCode == 204) {
      _showSnackBar(context, "List Deleted", Colors.red);
    } else {
      // List creation failed
      // Display an error message or handle the failure
      print('Failed to delete list. Status code: ${response.statusCode}');
    }
  }
}

void _settingsOnAction(int id, BuildContext context) {
  print(id);
  _showSnackBar(context, "List Deleted", const Color.fromARGB(255, 89, 83, 83));
}

void _showSnackBar(BuildContext context, String _mesaage, Color color) {
  final snackBar = SnackBar(
    content: Text(_mesaage),
    backgroundColor: color,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
