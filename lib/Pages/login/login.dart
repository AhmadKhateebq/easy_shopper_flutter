import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Apis/LoginApis.dart';
import 'package:graduation_project/Apis/NotificationApis.dart';
import 'package:graduation_project/Pages/admin/admin_page.dart';
import 'package:graduation_project/Style/borders.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../customer/customer_main.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
    return _LoginHomeState();
  }
}

class _LoginHomeState extends State<LoginHome> {
  TextEditingController usernameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  bool isLoading = false;

  showAlert(String msg) {
    showDialog(
      context: context,
      builder: (alertContext) {
        return AlertDialog(
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(alertContext).pop();
              },
              child: Text(
                "OK",
                style: TextStyle(color: AppBorders.appColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;

    final facebookLoginButton = ElevatedButton.icon(
      onPressed: () async {
        LoginApis.loginWithFacebook();
      },
      icon: Icon(Icons.facebook),
      label: Text('Login with Facebook'),
    );

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 229, 229),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: screenHeight * 0.2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: CircleAvatar(
                  backgroundColor: AppBorders.appColor,
                  radius: screenWidth * 0.15,
                  child: Image.asset(
                    "lib/Assets/Images/cart.png",
                    width: screenWidth * 0.15,
                    height: screenHeight * 0.15,
                  ),
                ),
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
                        decoration: AppBorders.txtFieldDecoration(
                          "Username",
                          prefIcon: Icon(Icons.person),
                        ),
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
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.07,
                      child: ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () {
                                var username = usernameCont.text;
                                var password = passwordCont.text;

                                if (username.isEmpty || password.isEmpty) {
                                  showAlert("Empty username or password");
                                  return;
                                }
                                setState(() {
                                  isLoading = true;
                                });
                                LoginApis.login(username, password).then(
                                  (value) {
                                    String response = value.body;
                                    print("login response: " +
                                        response +
                                        "status ${value.statusCode}");
                                    print(value.statusCode);
                                    if (value.statusCode == 200 ||
                                        value.statusCode == 201) {
                                      SharedPreferences.getInstance()
                                          .then((prefs) {
                                        if (response == "1477") {
                                          prefs.setString(
                                              "userToken", response);
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return AdminHomePage();
                                              },
                                            ),
                                          );
                                        } else {
                                          List<String> userInfo =
                                              response.split(",");
                                          int userId = int.parse(userInfo[1]);
                                          prefs.setString(
                                              "userToken", userInfo[0]);
                                          prefs.setInt("userId", userId);
                                          //send notification token
                                          FirebaseMessaging.instance
                                              .getToken()
                                              .then((value) => {
                                                    NotificationApis.addUser(
                                                        userId, value!)
                                                  });
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return CustomerHomePage();
                                              },
                                            ),
                                          );
                                        }
                                      });
                                    } else if (value.statusCode == 418) {
                                      showAlert("Wrong username or password");
                                    } else {
                                      showAlert("Something went wrong");
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                );
                              },
                        icon: isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Icon(
                                Icons.login,
                                size: screenWidth * 0.07,
                              ),
                        label: Text(
                          "Login",
                          style: TextStyle(fontSize: screenWidth * 0.05),
                        ),
                        style: AppBorders.btnStyle(),
                      ),
                    ),
                    facebookLoginButton,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
