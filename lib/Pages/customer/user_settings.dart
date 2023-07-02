import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduation_project/Style/borders.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Apis/UserApis.dart';
import 'model/user_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Settings Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserSettingsPage(),
    );
  }
}

class UserSettingsPage extends StatefulWidget {
  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  late int _userId = 4;
  late AppUser _user = AppUser(username: "", fname: "", lname: "", email: "");
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  double _searchDistance = 0.5;

  @override
  void initState() {
    super.initState();
    _setPrefs();
    _fetchUserId();
    _fetchUserData();
  }

  Future<void> _fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('userId') ?? 4;
  }

  Future<void> _setPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userToken", "1477");
    prefs.setInt("userId", 4);
    prefs.setDouble("radius", 0.5);
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await UserApi.getUser(_userId);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final user = AppUser.fromJson(jsonData);
        setState(() {
          _user = user;
          _usernameController.text = user.username;
          _fnameController.text = user.fname;
          _lnameController.text = user.lname;
          _emailController.text = user.email;
        });
      } else {
        throw Exception('Failed to get user data');
      }
    } catch (e) {
      print('Exception: $e');
      // Handle error
    }
  }

  Future<void> _updateUser() async {
    final updatedUser = AppUser(
      id: _user.id,
      username: _usernameController.text,
      fname: _fnameController.text,
      lname: _lnameController.text,
      email: _emailController.text,
      facebookId: _user.facebookId,
      googleId: _user.googleId,
      pictureUrl: _user.pictureUrl,
    );
    try {
      final response = await UserApi.updateUser(updatedUser);
      if (response.statusCode == 200) {
        // Show success message or perform any additional actions
      } else if (response.statusCode == 406) {
        throw Exception('username exists');
      } else
        throw Exception("failed to update user");
    } catch (e) {
      print('Exception: $e');
      // Handle error
    }
  }

  void _showPasswordDialog() async {
    final TextEditingController _currentPasswordController =
        TextEditingController();
    final TextEditingController _newPasswordController =
        TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Current Password',
                    ),
                  ),
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                    ),
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String currentPassword = _currentPasswordController.text;
                String newPassword = _newPasswordController.text;
                String confirmPassword = _confirmPasswordController.text;
                if (newPassword == confirmPassword) {
                  Response response = await UserApi.updatePassword(
                    _userId,
                    currentPassword,
                    newPassword,
                  );
                  if (response.statusCode == 200) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Password updated'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Ok'),
                              ),
                            ],
                          );
                        });
                    Navigator.of(context).pop();
                  } else if (response.statusCode == 401) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('current password is Incorrect'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Ok'),
                              ),
                            ],
                          );
                        });
                  } else if (response.statusCode == 406) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                'New password must be different from the current password'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Ok'),
                              ),
                            ],
                          );
                        });
                  }
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Current password doesnt match'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Ok'),
                            ),
                          ],
                        );
                      });
                }
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _setSearchDistance(double distance) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble("radius", distance);
    print(prefs.get("radius"));
    setState(() {
      _searchDistance = distance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildFormField(
                controller: _usernameController,
                labelText: 'Username',
              ),
              _buildFormField(
                controller: _fnameController,
                labelText: 'First Name',
              ),
              _buildFormField(
                controller: _lnameController,
                labelText: 'Last Name',
              ),
              _buildFormField(
                controller: _emailController,
                labelText: 'Email',
              ),
              _buildConnectionStatus('Facebook', _user.facebookId != null),
              _buildConnectionStatus('Google', _user.googleId != null),
              _buildElevatedButton(
                  onPress: _updateUser, text: 'Update user info'),
              SizedBox(height: 20),
              _buildElevatedButton(
                  onPress: _showPasswordDialog, text: 'Change Password'),
              SizedBox(height: 20),
              Text(
                'Search Distance',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Slider(
                value: _searchDistance,
                min: 0.5,
                max: 10.0,
                divisions: 19,
                onChanged: (double value) {
                  setState(() {
                    _setSearchDistance(value);
                  });
                },
                label: _searchDistance.toString() + ' km',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return TextFormField(
      controller: controller,
      // decoration: InputDecoration(
      //   labelText: labelText,
      //   suffixIcon: Icon(Icons.edit),
      // ),
      decoration: AppBorders.txtFieldDecoration(labelText),
    );
  }

  Widget _buildElevatedButton({
    required VoidCallback onPress,
    required String text,
  }) {
    return ElevatedButton(
      onPressed: onPress,
      child: Text(text),
      style: AppBorders.btnStyle(),
    );
  }

  Widget _buildConnectionStatus(String platform, bool isConnected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            'Connected to $platform',
            style: TextStyle(
              fontSize: 16,
              color: isConnected ? Colors.green : Colors.red,
            ),
          ),
          SizedBox(width: 10),
          Icon(
            isConnected ? Icons.check_circle : Icons.cancel,
            color: isConnected ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}
