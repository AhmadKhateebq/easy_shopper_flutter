import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graduation_project/Apis/LoginApis.dart';
import 'package:graduation_project/Pages/Regestration/userInfo.dart';
import 'package:graduation_project/Pages/admin/admin_page.dart';
import 'package:graduation_project/Style/borders.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constants/connection.dart';

void main() {
  //in each app run check if the user is logged in or not
  //SharedPreferences.getInstance();
  runApp(_Login());
}

class _Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: AppBorders.themeData,
      home: LoginHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginHomeState();
  }
}

class _LoginHomeState extends State<LoginHome> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;

    TextEditingController usernameCont = new TextEditingController();
    TextEditingController passwordCont = new TextEditingController();

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 229, 229, 229),
        body: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3)),
                  child: CircleAvatar(
                      backgroundColor: AppBorders.appColor,
                      radius: screenWidth * 0.15,
                      child: Image.asset(
                        "lib/Assets/Images/cart.png",
                        width: screenWidth * 0.15,
                        height: screenHeight * 0.15,
                      )),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  margin: EdgeInsets.all(screenWidth * 0.05),
                  decoration: AppBorders.containerDecoration(),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                        child: TextFormField(
                          controller: usernameCont,
                          decoration: AppBorders.txtFieldDecoration("Username",
                              prefIcon: Icon(Icons.person)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                        child: TextFormField(
                            controller: passwordCont,
                            obscureText: true,
                            decoration: AppBorders.txtFieldDecoration(
                              "Password",
                              prefIcon: const Icon(Icons.lock),
                            )),
                      ),
                      SizedBox(
                          width: double.infinity,
                          height: screenHeight * 0.07,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              var username = usernameCont.text,
                                  password = passwordCont.text;

                              LoginApis.login(username, password).then((value) {
                                String response = value.body;
                                print("login response: " +
                                    response +
                                    "status ${value.statusCode}");
                                print(value.statusCode);
                                if (value.statusCode == 200 ||
                                    value.statusCode == 201) {
                                  //store token in the session
                                  SharedPreferences.getInstance().then((prefs) {
                                    prefs.setString("userToken", response);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return HomePage();
                                    }));
                                  });
                                } else if (value.statusCode == 418) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: const Text(
                                              "Wrong Username or Password"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "OK",
                                                  style: TextStyle(
                                                      color:
                                                          AppBorders.appColor),
                                                ))
                                          ],
                                        );
                                      });
                                }
                              });
                            },
                            icon: Icon(
                              Icons.login,
                              size: screenWidth * 0.07,
                            ),
                            label: Text("Login",
                                style: TextStyle(fontSize: screenWidth * 0.05)),
                            style: AppBorders.btnStyle(),
                          )),
                      SizedBox(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Dont have an account?"),
                          TextButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return UserInfo();
                                }));
                              },
                              child: Text(
                                "Create Account",
                                style: TextStyle(color: AppBorders.appColor),
                              ))
                        ],
                      ))
                    ],
                  ),
                ),
              ],
            )));
  }
}
