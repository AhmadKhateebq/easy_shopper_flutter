import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduation_project/Apis/ListApis.dart';
import 'package:graduation_project/Pages/customer/add_item.dart';
import 'package:graduation_project/Pages/customer/googleMap/google_map_page.dart';
import 'package:graduation_project/Pages/customer/model/list_data.dart';
import 'package:graduation_project/Pages/customer/model/product_data.dart';
import 'package:http/http.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../Style/borders.dart';

// ignore: must_be_immutable
class CustomerListPage extends StatefulWidget {
  int? listId;
  CustomerListPage(int _listId) {
    this.listId = _listId;
  }

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  late String _listname = "";
  late int _userId = 0;
  UserList _list = UserList.emptyList();
  List<Product> productList = List.empty(growable: true);
  bool canEdit = false;
  //if list.userId == user id in shared prefs
  //else if user id in shared prefs = (search in list.sharedWith where user id == user id in shared & can edit)
  Future<void> _fetchUserList() async {
    Response response = await ListApis.getListById(widget.listId.toString());
    if (response.statusCode == 200) {
      var prefs = await SharedPreferences.getInstance();
      int? currentUserId = prefs.getInt("userId");
      _userId = currentUserId!;
      if (!mounted) return;
      setState(() {
        _list = UserList.fromJson(jsonDecode(response.body));
        if (_list.userId == currentUserId) {
          canEdit = true;
        } else {
          _list.usersSharedWith.forEach((user) {
            if (user.userId == currentUserId && user.canEdit) {
              canEdit = true;
            }
          });
        }

        productList = _list.items;
        _listname = _list.name;
      });
    } else {
      setState(() {
        print('Request failed with status: ${response.statusCode}');
        _list = UserList.emptyList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
                child: Text(
              _listname,
              style: TextStyle(fontSize: 16),
            )),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                _editNickname();
              },
            ),
          ],
        ),
        backgroundColor: AppBorders.appColor,
        elevation: 10,
        centerTitle: true,
        actions: [
          canEdit
              ? IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 30,
                  ),
                  alignment: Alignment.topLeft,
                  onPressed: () async {
                    await Navigator.push(context,
                        new MaterialPageRoute(builder: (context) {
                      return AddItem(widget.listId!);
                    }));
                    _fetchUserList();
                  },
                )
              : SizedBox.shrink(),
        ],
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  children: productList.map((product) {
                    return Card(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(product.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.0),
                                Text(product.category),
                                SizedBox(
                                  height: 4.0,
                                ),
                                canEdit
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton.icon(
                                              onPressed: () {
                                                ListApis.removeItemFromUserList(
                                                        widget.listId
                                                            .toString(),
                                                        product.id.toString())
                                                    .then((delResponse) {
                                                  print(
                                                      "remove item from user list : ${delResponse.body}");
                                                  _fetchUserList();
                                                });
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: AppBorders.appColor,
                                              ),
                                              label: Text(
                                                "Delete Item",
                                                style: TextStyle(
                                                    color: AppBorders.appColor),
                                              ))
                                        ],
                                      )
                                    : SizedBox.shrink()
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(bottom: 50),
                  width: 250,
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        var prefs = await SharedPreferences.getInstance();
                        prefs.setInt("listId", widget.listId!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GoogleMapHomePage()),
                        );
                      },
                      style: AppBorders.btnStyle(),
                      label: Text(
                        'Find Supermarkets',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ))
          ],
        ),
        margin: EdgeInsets.only(top: 10),
      )),
    );
  }

  _editNickname() async {
    String? newNickname = await showDialog(
      context: context,
      builder: (BuildContext context) {
        String? enteredText;
        return AlertDialog(
          title: Text('Edit Nickname'),
          content: TextField(
            onChanged: (value) {
              enteredText = value;
            },
            decoration: InputDecoration(
              labelText: 'Enter new nickname',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                Navigator.of(context).pop(enteredText);
                if (enteredText != null) {
                  await ListApis.setNickname(_userId, _list.id, enteredText!);
                }
              },
            ),
          ],
        );
      },
    );

    if (newNickname != null) {
      setState(() {
        _list.name = newNickname;
        _listname = newNickname;
      });
    }
  }
}
