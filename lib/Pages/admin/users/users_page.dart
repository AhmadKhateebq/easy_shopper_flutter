import 'package:flutter/material.dart';
import 'package:graduation_project/Style/borders.dart';

class UsersPage extends StatelessWidget {
  List<dynamic> usersList = [];
  UsersPage(usersList) {
    this.usersList = usersList;
  }

  @override
  Widget build(BuildContext context) {
    if (!usersList.isEmpty) {
      print(usersList);
    }
    return Container(
        child: usersList.isEmpty
            ? Text("Empty Users List")
            : Align(
                alignment: Alignment.center,
                child: Container(
                  child: ListView(
                    children: [
                      for (int i = 0; i < usersList.length; i++)
                        Container(
                          decoration: AppBorders.containerDecoration(),
                          margin:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text(usersList[i][1].toString()),
                              subtitle: Text("# ${usersList[i][0].toString()}"),
                              trailing: Material(
                                child: InkWell(
                                  radius: 20,
                                  borderRadius: BorderRadius.circular(50),
                                  child: Icon(
                                    Icons.remove_circle,
                                  ),
                                  onTap: () {},
                                ),
                              )),
                        )
                    ],
                  ),
                )));
  }
}
