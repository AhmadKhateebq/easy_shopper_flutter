import 'package:flutter/material.dart';
import 'package:graduation_project/Style/borders.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Apis/UserApis.dart';
import 'user_settings.dart';

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _currentVisible = false;
  bool _newVisible = false;
  bool _confirmVisible = false;
  final FocusNode currentPasswordFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  late int _userId = 4;

  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('userId') ?? 4;
  }

  Widget _buildSuffixIcon(FocusNode focusNode, bool showPassword) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      transformAlignment: Alignment.center,
      transform: Matrix4.rotationY(showPassword ? 0 : 3.14159),
      child: IconButton(
        icon: Icon(
          showPassword ? Icons.visibility : Icons.visibility_off,
          color: showPassword ? AppBorders.appColor : Colors.black45,
        ),
        onPressed: () => _onPressSetState(focusNode),
      ),
    );
  }

  _onPressSetState(FocusNode focusNode) {
    setState(() {
      if (focusNode == currentPasswordFocusNode) {
        _showNewPassword = false;
        _showConfirmPassword = false;
        _showCurrentPassword = !_showCurrentPassword;
      } else if (focusNode == newPasswordFocusNode) {
        _showCurrentPassword = false;
        _showConfirmPassword = false;

        _showNewPassword = !_showNewPassword;
      } else if (focusNode == confirmPasswordFocusNode) {
        _showCurrentPassword = false;
        _showNewPassword = false;
        _showConfirmPassword = !_showConfirmPassword;
      }
    });
  }

  Widget _buildVisibility(Widget iconButton, bool visiblity) {
    return Visibility(
      child: iconButton,
      visible: visiblity,
    );
  }

  void _onChange(FocusNode focusNode) {
    setState(() {
      // Reset the showPassword flags for all fields

      // Update the showPassword flag for the focused field
      if (focusNode == currentPasswordFocusNode) {
        _showNewPassword = false;
        _showConfirmPassword = false;
        _confirmVisible = false;
        _currentVisible = true;
        _newVisible = false;
      } else if (focusNode == newPasswordFocusNode) {
        _showCurrentPassword = false;
        _showConfirmPassword = false;
        _confirmVisible = false;
        _currentVisible = false;
        _newVisible = true;
      } else if (focusNode == confirmPasswordFocusNode) {
        _showCurrentPassword = false;
        _showNewPassword = false;
        _confirmVisible = true;
        _currentVisible = false;
        _newVisible = false;
      }
    });
  }

  TextFormField _buildTextField(String text, TextEditingController Controller,
      FocusNode focusNode, bool obscure, bool visiblity) {
    focusNode.addListener(() {
      _onChange(focusNode);
    });
    return TextFormField(
      controller: Controller,
      focusNode: focusNode,
      obscureText: !obscure,
      decoration: AppBorders.passwordFieldDecoration(
        text,
        _buildVisibility(_buildSuffixIcon(focusNode, obscure), visiblity),
      ),
    );
  }

  @override
  void dispose() {
    currentPasswordFocusNode.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: AppBorders.appColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Replace with your desired icon
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    UserSettingsPage(), // Replace with your desired page
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
                "Current Password",
                currentPasswordController,
                currentPasswordFocusNode,
                _showCurrentPassword,
                _currentVisible),
            SizedBox(height: 20.0),
            _buildTextField("New Password", newPasswordController,
                newPasswordFocusNode, _showNewPassword, _newVisible),
            SizedBox(height: 20.0),
            _buildTextField(
                "Confirm Password",
                confirmPasswordController,
                confirmPasswordFocusNode,
                _showConfirmPassword,
                _confirmVisible),
            SizedBox(height: 20.0),
            Row(
              children: [
                ElevatedButton(
                  style: AppBorders.btnStyle(),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserSettingsPage(),
                      ),
                    );
                  },
                  child: Text('Cancel'),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  style: AppBorders.btnStyle(),
                  onPressed: _updatePassword,
                  child: Text('Update'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _updatePassword() async {
    String currentPassword = currentPasswordController.text;
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserSettingsPage(),
                        ),
                      );
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
  }
}
