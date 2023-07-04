import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduation_project/Apis/ListApis.dart';
import 'package:graduation_project/Apis/UserApis.dart';
import 'package:graduation_project/Pages/customer/model/list_data.dart';
import 'package:graduation_project/Pages/customer/model/user_name_data.dart';
import 'package:http/http.dart';

import '../../Style/borders.dart';
import 'customer_main.dart';

// ignore: must_be_immutable
class ListSettingsPage extends StatefulWidget {
  int? listId;
  ListSettingsPage(this.listId);
  @override
  State<ListSettingsPage> createState() => _ListSettingsPageState();
}

class _ListSettingsPageState extends State<ListSettingsPage> {
  late UserList _list;
  late UserList _editedUserList;
  late AppUserUsername selectedUser;
  late List<AppUserUsername> _userList;
  String searchQuery = ''; // State variable to store the search query

  List<AppUserUsername> filteredUsers =
      []; // List to store the filtered users based on the search query

  @override
  void initState() {
    _fetchUserList();
    _fetchUsers();
    _editedUserList = UserList.copy(_list);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Settings'),
        backgroundColor: AppBorders.appColor,
        leading: IconButton(
          icon: Icon(Icons.home), // Replace with your desired icon
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    CustomerHomePage(), // Replace with your desired page
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: _editedUserList.name,
                decoration: InputDecoration(labelText: 'List Name'),
                onChanged: (value) {
                  setState(() {
                    _editedUserList.name = value;
                  });
                },
              ),
              SizedBox(height: 18),
              SwitchListTile(
                title: Text('Private List'),
                value: _editedUserList.isPrivate,
                onChanged: (value) {
                  setState(() {
                    _editedUserList.isPrivate = value;
                  });
                },
              ),
              SizedBox(height: 18),
              Visibility(
                  visible: _editedUserList.isPrivate, child: searchField())
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveAndNavigateBack();
        },
        child: Icon(Icons.save),
      ),
    );
  }

  void _saveAndNavigateBack() async {
    _list = _editedUserList;
    await ListApis.updateList(_list);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerHomePage(),
      ),
    );
  }

  _fetchUserList() async {
    Response response = await ListApis.getListById(widget.listId.toString());
    if (response.statusCode == 200) {
      _list = UserList.fromJson(jsonDecode(response.body));
    } else {
      print('Request failed with status: ${response.statusCode}');
      _list = UserList.emptyList();
    }
  }

  _fetchUsers() async {
    Response response = await UserApi.getAllUserNames();
    if (response.statusCode == 200) {
      _userList = (jsonDecode(response.body) as Map<String, dynamic>)
          .values
          .map((userJson) => AppUserUsername.fromJson(userJson))
          .toList();
    } else {
      print('Request failed with status: ${response.statusCode}');
      _userList = [];
    }
  }

  void filterUsers(String query) {
    setState(() {
      searchQuery = query;
      filteredUsers = _userList
          .where((user) =>
              user.username.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Widget searchField() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Search by Username'),
          onChanged: filterUsers,
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final user = filteredUsers[index];
            return ListTile(
              title: Text(user.username),
              onTap: () {
                setState(() {
                  selectedUser = user;
                });
              },
            );
          },
        ),
      ],
    );
  }
}
