// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduation_project/Apis/AdminApis.dart';
import 'package:graduation_project/Style/borders.dart';

import '../../../Apis/LoginApis.dart';

class UsersPage extends StatefulWidget {
  List<dynamic> usersList = [];

  UsersPage(usersList) {
    this.usersList = usersList;
  }
  @override
  State<StatefulWidget> createState() {
    return UsersPageState(usersList);
  }
}

class UsersPageState extends State {
  List<dynamic> usersList = [];
  UsersPageState(usersList) {
    this.usersList = usersList;
  }

  void showAlert(String msg) {
    showDialog(
        context: context,
        builder: (alertContext) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(alertContext).pop();
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: AppBorders.appColor),
                  ))
            ],
            content: Text(msg),
          );
        });
  }

  getUsers() {
    LoginApis.getUser().then((resp) {
      print("get all users list: " +
          resp.body +
          "status code ${resp.statusCode}");
      try {
        List<dynamic> list = jsonDecode(resp.body);
        var temp = List.empty(growable: true);
        setState(() {
          list.forEach((element) {
            print(element);
            temp.add({
              "id": element["id"],
              "username": element["username"],
              "fname": element["fname"],
              "email": element["email"],
              "lname": element["lname"]
            });
          });
          print(temp);
          usersList = temp;
        });
      } on Exception catch (e) {
        print("list exception: " + e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!usersList.isEmpty) {
      print(usersList);
    }
    return Container(
        child: Align(
            alignment: Alignment.center,
            child: Container(
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            getUsers();
                          },
                          icon: Icon(Icons.refresh)),
                      Text("Refresh List")
                    ],
                  ),
                  usersList.isEmpty
                      ? Align(
                          alignment: Alignment.center,
                          child: Text("Empty Users List"),
                        )
                      : Column(
                          children: [
                            for (int i = 0; i < usersList.length; i++)
                              Container(
                                decoration: AppBorders.containerDecoration(),
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                child: ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text(
                                        usersList[i]["username"].toString()),
                                    subtitle: Text(
                                        "# ${usersList[i]["id"].toString()}"),
                                    trailing: Material(
                                      child: InkWell(
                                        radius: 20,
                                        borderRadius: BorderRadius.circular(50),
                                        splashColor: Colors.grey,
                                        child: Icon(
                                          Icons.remove_circle,
                                          color: AppBorders.appColor,
                                        ),
                                        onTap: () {
                                          String username = usersList[i]
                                                      ["username"]
                                                  .toString(),
                                              id =
                                                  usersList[i]["id"].toString();

                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Text(
                                                      "Do you want to delete the user (${username}) ?"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          AdminApis.deleteUser(
                                                                  id)
                                                              .then((response) {
                                                            print(
                                                                "delete user response ${response.body} , status ${response.statusCode}");
                                                            if (response
                                                                    .statusCode ==
                                                                202) {
                                                              getUsers();
                                                            } else {
                                                              showAlert(
                                                                  "Error :  Couldn't delete user");
                                                            }
                                                          });
                                                        },
                                                        child: Text("Yes")),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text("No"))
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                    )),
                              )
                          ],
                        )
                ],
              ),
            )));
  }
}
