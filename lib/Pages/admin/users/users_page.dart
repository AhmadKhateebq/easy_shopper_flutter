import 'package:flutter/material.dart';

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
            ? CircularProgressIndicator()
            : Align(
                alignment: Alignment.center,
                child: Container(
                  child: ListView(
                    children: [
                      for (int i = 0; i < usersList.length; i++)
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text(usersList[i][1].toString()),
                          subtitle: Text("# ${usersList[i][0].toString()}"),
                        )
                    ],
                  ),
                )));
  }
}
