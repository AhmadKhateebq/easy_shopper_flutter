import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:graduation_project/Apis/ListApis.dart';
import 'package:graduation_project/Apis/UserApis.dart';
import 'package:graduation_project/Pages/customer/model/list_data.dart';
import 'package:graduation_project/Pages/customer/model/user_name_data.dart';

import '../../Style/borders.dart';
import 'customer_main.dart';
import 'loadingScreens/loadingScreen2.dart';

class ListSettingsPage extends StatefulWidget {
  final int? listId;

  ListSettingsPage(this.listId);

  @override
  State<ListSettingsPage> createState() => _ListSettingsPageState();
}

class _ListSettingsPageState extends State<ListSettingsPage> {
  late UserList _list = UserList.emptyList();
  late UserList _editedUserList = UserList.emptyList();
  late AppUserUsername selectedUser = AppUserUsername(id: 0, username: "");
  late SharedWith selectedSharedWith = SharedWith(userId: 0, canEdit: false);
  late List<AppUserUsername> _userList = [];
  List<SharedWith> sharedWithList = [];
  String searchQuery = '';
  bool _isLoading = true;

  List<AppUserUsername> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await _fetchUserList();
    await _fetchUsers();
    _editedUserList = UserList.copy(_list);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Settings'),
        backgroundColor: AppBorders.appColor,
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CustomerHomePage(),
              ),
            );
          },
        ),
      ),
      body: _isLoading
          ? LoadingScreen2()
          : SingleChildScrollView(
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
                          _editedUserList.isPrivate =
                              !_editedUserList.isPrivate;
                          value = !value;
                        });
                      },
                    ),
                    SizedBox(height: 18),
                    Visibility(
                      visible: !_editedUserList.isPrivate,
                      child: searchField(),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppBorders.appColor,
        onPressed: () {
          _saveAndNavigateBack();
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Future<void> _saveAndNavigateBack() async {
    _list = _editedUserList;
    _list.usersSharedWith = sharedWithList;
    await ListApis.updateList(_list);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerHomePage(),
      ),
    );
  }

  Future<void> _fetchUserList() async {
    Response response = await ListApis.getListById(widget.listId.toString());
    if (response.statusCode == 200) {
      _list = UserList.fromJson(jsonDecode(response.body));
      sharedWithList = _list.usersSharedWith;
    } else {
      print('Request failed with status: ${response.statusCode}');
      _list = UserList.emptyList();
    }
  }

  Future<void> _fetchUsers() async {
    Response response = await UserApi.getAllUserNames();
    if (response.statusCode == 200) {
      dynamic responseBody = jsonDecode(response.body);
      if (responseBody is List) {
        _userList = responseBody
            .map((userJson) => AppUserUsername.fromJson(userJson))
            .toList();
      } else if (responseBody is Map<String, dynamic>) {
        _userList = responseBody.values
            .map((userJson) => AppUserUsername.fromJson(userJson))
            .toList();
      } else {
        print('Invalid response body');
        _userList = [];
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
      _userList = [];
    }
  }

  void filterUsers(String query) {
    setState(() {
      searchQuery = query;
      if (query.isNotEmpty)
        filteredUsers = _userList
            .where((user) =>
                user.username.toLowerCase().contains(query.toLowerCase()))
            .where((user) => !sharedWithList.contains(user))
            .toList();
      else
        filteredUsers = [];
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
            final isUserShared = sharedWithList
                .any((sharedUser) => sharedUser.userId == user.id);
            return !isUserShared
                ? ListTile(
                    title: Text(user.username),
                    onTap: () {
                      setState(() {
                        sharedWithList
                            .add(SharedWith(userId: user.id, canEdit: false));
                      });
                    },
                  )
                : SizedBox.shrink();
          },
        ),
        ...sharedWithList.map((sharedUser) {
          final user =
              _userList.firstWhere((user) => user.id == sharedUser.userId);
          return ListTile(
              title: Text(user.username),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "can Edit",
                    style: TextStyle(color: Colors.black.withOpacity(0.7)),
                  ),
                  Switch(
                    value: sharedUser.canEdit,
                    onChanged: (value) {
                      setState(() {
                        sharedUser.canEdit = value;
                      });
                    },
                  ),
                ],
              ));
        }),
      ],
    );
  }
}
