import 'package:flutter/material.dart';
import 'package:graduation_project/Style/borders.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Apis/ListApis.dart';
import 'customer_main.dart';
import 'model/list_data.dart';

class CreateListScreen extends StatefulWidget {
  const CreateListScreen({Key? key}) : super(key: key);
  @override
  _CreateListScreenState createState() => _CreateListScreenState();
}

class _CreateListScreenState extends State<CreateListScreen> {
  TextEditingController _nameController = TextEditingController();
  bool _isPrivate = false;

  Future<void> createList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userId = preferences.getInt('userId');

    if (userId == null) {
      // User ID not found in shared preferences
      // Handle the scenario accordingly (e.g., display an error message)
      return;
    }
    // Get the values from the text field and checkbox
    String name = _nameController.text;
    bool isPrivate = _isPrivate;

    // Create the UserList object
    UserList userList = UserList(
      id: 0, // The ID will be assigned by the API
      name: name,
      isPrivate: isPrivate,
      userId: userId,
      usersSharedWith: [],
      items: [],
    );

    // Call the API to create the list
    http.Response response = await ListApis.createList(userList);

    if (response.statusCode == 200) {
      // List creation successful
      // Navigate to a specific page (replace with your desired page)
      // Navigator.pushReplacementNamed(context, '/customer_main');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomerHomePage()),
      );
    } else {
      // List creation failed
      // Display an error message or handle the failure
      print('Failed to create list. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create List'),
        backgroundColor: AppBorders.appColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'List Name',
              ),
            ),
            CheckboxListTile(
              title: Text('Private'),
              value: _isPrivate,
              onChanged: (value) {
                setState(() {
                  _isPrivate = value ?? false;
                });
              },
            ),
            ElevatedButton(
              onPressed: createList,
              style: AppBorders.btnStyle(),
              child: Text('Create List'),
            ),
          ],
        ),
      ),
    );
  }
}
