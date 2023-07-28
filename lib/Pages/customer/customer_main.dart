import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:graduation_project/Apis/NotificationApis.dart';
import 'package:graduation_project/Pages/customer/shared_with_user.dart';

import 'package:graduation_project/Style/borders.dart';
import 'package:graduation_project/Pages/customer/list_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Apis/ListApis.dart';
import '../../Utils/Notifications.dart';
import '../../firebase_options.dart';
import '../login/login.dart';
import 'create_list.dart';
import 'data_container.dart';
import 'list_settings.dart';
import 'model/list_data.dart';
import 'user_settings.dart';

final notficationPlugin = new FlutterLocalNotificationsPlugin();
StreamSubscription<RemoteMessage>? foregroundMsgStream;
StreamSubscription<RemoteMessage>? backgroundMsgStream;

@pragma("vm:entry-point")
Future<void> backgroundMsgHandler(RemoteMessage msg) async {
  print("message arrived ${msg.notification!.title}");
  NotificationsManager.showNotification(
      notficationPlugin, msg.notification!.title!, msg.notification!.body!);
}

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({Key? key}) : super(key: key);

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  late int _userid;
  late Future<List<UserList>> _userListFuture;

  Future<void> messageHandler(RemoteMessage msg) async {
    print("message arrived ${msg.notification!.title}");
    NotificationsManager.showNotification(
        notficationPlugin, msg.notification!.title!, msg.notification!.body!);
  }

  _setUpFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await NotificationsManager.initializeFLN(notficationPlugin);

    var permission = await Permission.notification.status;

    if (!permission.isGranted) {
      print("notification permission is not granted");
      await Permission.notification.request();
    }
    foregroundMsgStream = FirebaseMessaging.onMessage.listen(messageHandler);
    FirebaseMessaging.instance.getToken().then((value) {
      print("firebase token : ${value}");
    });
  }

  @override
  void dispose() {
    print("customer_main dispose called");
    if (foregroundMsgStream != null) foregroundMsgStream!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _userid = 0;
    _userListFuture = initializeUser();
    _setUpFirebase();
  }

  Future<List<UserList>> initializeUser() async {
    print("user list loaded");
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
                leading: Icon(Icons.share),
                title: Text("Shared with me"),
                onTap: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (context) {
                    return SharedWithUser();
                  }));
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("User settings"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserSettingsPage()));
                },
              ),
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
                                            ListSettingsPage(list.id)),
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
        onTap: () async {
          productList = list.items;
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomerListPage(list.id)),
          );
          setState(() {
            _userListFuture = initializeUser();
          });
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
                    FirebaseMessaging.instance.getToken().then((value) =>
                        {NotificationApis.deleteUserTokin(_userid, value!)});
                    Navigator.of(alertContext).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                        new MaterialPageRoute(builder: (context) {
                      return Login();
                    }), (route) => route.isFirst);
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

  settingsList(BuildContext context, int id) {
    print("entered");
    (context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListSettingsPage(id)),
        );
  }

  Future<void> _deleteOnAction(int id, BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userId = preferences.getInt('userId');
    if (userId == null) {
      return;
    }
    http.Response response = await ListApis.removeList(id, userId);
    if (response.statusCode == 204) {
      print(id);
    } else {
      // List creation failed
      // Display an error message or handle the failure
      print('Failed to delete list. Status code: ${response.statusCode}');
    }
  }
}

void sharedWithMe(BuildContext context) {
  AlertDialog(
    content: Text("Do you want to log out ?"),
    actions: [
      TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateListScreen(),
                ));
          },
          child: Text("Yes")),
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("No"))
    ],
  );
}
