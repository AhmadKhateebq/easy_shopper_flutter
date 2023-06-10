import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Apis/LoginApis.dart';
import 'package:graduation_project/Pages/admin/admin_page.dart';
import 'package:graduation_project/Style/borders.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _UserInfoHome());
  }
}

class _UserInfoHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserInfoHomeState();
  }
}

class _UserInfoHomeState extends State<_UserInfoHome> {
  final _formKey = GlobalKey<FormState>();
  bool validPassword = false;

  void showAlert(String msg, {bool? switchToLogin}) {
    showDialog(
        context: context,
        builder: (alertContext) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    if (switchToLogin == null || switchToLogin == false)
                      Navigator.of(alertContext).pop();
                    else {
                      Navigator.of(alertContext).pop();
                      Navigator.of(context).pushReplacement(
                          new MaterialPageRoute(builder: (context) {
                        return AdminHomePage();
                      }));
                    }
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: AppBorders.appColor),
                  ))
            ],
            content: Text(msg),
          );
        });
  }

  TextEditingController userNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 229, 229),
      body: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3)),
                child: CircleAvatar(
                    backgroundColor: AppBorders.appColor,
                    radius: screenWidth * 0.15,
                    child: Icon(
                      Icons.account_box_rounded,
                      color: Colors.white,
                      size: screenWidth * 0.11,
                    )),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(screenWidth * 0.05),
                child: Text(
                  "User Regestration",
                  style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      color: Color.fromARGB(255, 144, 144, 144)),
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.035),
                  margin: EdgeInsets.all(screenWidth * 0.05),
                  decoration: AppBorders.containerDecoration(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (val) {
                              if (val!.isEmpty)
                                return ("Please fill the username");
                              else if (val.length < 3 || val.length > 16)
                                return ("username must be 3-16 characters");

                              return null;
                            },
                            controller: userNameController,
                            decoration: AppBorders.txtFieldDecoration(
                                "Username",
                                prefIcon: Icon(Icons.person)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                          child: TextFormField(
                              controller: firstNameController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (val) {
                                if (val!.isEmpty)
                                  return ("Please fill the first name");

                                return null;
                              },
                              decoration: AppBorders.txtFieldDecoration(
                                  "First Name",
                                  prefIcon: Icon(Icons.person))),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                          child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: lastNameController,
                              validator: (val) {
                                if (val!.isEmpty)
                                  return ("Please enter your last name");

                                return null;
                              },
                              decoration: AppBorders.txtFieldDecoration(
                                  "Last Name",
                                  prefIcon: Icon(Icons.person))),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                          child: TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !EmailValidator.validate(value, true)) {
                                  return "Please enter valid email address";
                                }
                                return null;
                              },
                              decoration: AppBorders.txtFieldDecoration("Email",
                                  prefIcon: Icon(Icons.email))),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                          child: TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: AppBorders.txtFieldDecoration(
                                  "Password",
                                  prefIcon: Icon(Icons.lock))),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                          child: FlutterPwValidator(
                              controller: passwordController,
                              minLength: 6,
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.1,
                              onSuccess: () {
                                validPassword = true;
                              },
                              onFail: () {
                                validPassword = false;
                              }),
                        ),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  String username =
                                          userNameController.text.trim(),
                                      fname = firstNameController.text.trim(),
                                      lname = lastNameController.text.trim(),
                                      email = emailController.text.trim(),
                                      password = passwordController.text;
                                  print("success ");
                                  print("password: ${password} ");
                                  if (!validPassword) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: const Text(
                                                "Please enter strong password"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "OK",
                                                    style: TextStyle(
                                                        color: AppBorders
                                                            .appColor),
                                                  ))
                                            ],
                                          );
                                        });
                                    return;
                                  }
                                  LoginApis.registerUser(username, fname, lname,
                                          email, password)
                                      .then((response) {
                                    print(
                                        "register user response: ${response.body} status Code: ${response.statusCode}");
                                    if (response.statusCode == 200 ||
                                        response.statusCode == 201) {
                                      SharedPreferences.getInstance()
                                          .then((prefs) {
                                        prefs.setString(
                                            "userToken", response.body);
                                        showAlert("Account Created Successfuly",
                                            switchToLogin: true);
                                      });
                                    } else if (response.statusCode == 401) {
                                      showAlert(
                                          "Registration Failed : Unautharized");
                                    } else if (response.statusCode == 404) {
                                      showAlert(
                                          "Registration Failed : Not Found");
                                    } else if (response.statusCode == 403) {
                                      showAlert(
                                          "Registration Failed : Forbidden");
                                    } else {
                                      showAlert(
                                          "Something went wrong , please try again later");
                                    }
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.assignment,
                                size: screenWidth * 0.07,
                              ),
                              label: Text("Submit Info",
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.05)),
                              style: AppBorders.btnStyle(),
                            )),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.cancel,
                                size: screenWidth * 0.07,
                              ),
                              label: Text("Cancel",
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.05)),
                              style: AppBorders.btnStyle(),
                            )),
                      ],
                    ),
                  )),
            ],
          )),
    );
    /*  return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: const Text(
                "User Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              margin: EdgeInsets.only(top: 5),
            ),
           Center(child: Container(
              decoration: AppBorders.containerDecoration(),
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max
                ,children: [
                TextFormField(
                    decoration: AppBorders.txtFieldDecoration("Username",
                        prefIcon: Icon(Icons.person))),
                const SizedBox(height: 20,),
                TextFormField(
                    decoration: AppBorders.txtFieldDecoration("First Name",
                        prefIcon: Icon(Icons.person))),
                const SizedBox(height: 20,),
                TextFormField(
                    decoration: AppBorders.txtFieldDecoration("Last Name",
                        prefIcon: Icon(Icons.person))),
               const SizedBox(height: 20,),
               TextFormField(
                    decoration: AppBorders.txtFieldDecoration("Email",
                        prefIcon: Icon(Icons.email))),
                const SizedBox(height: 20,),
                TextFormField(
                    decoration: AppBorders.txtFieldDecoration("Password",
                        prefIcon: Icon(Icons.lock))),

              ]),
            ) ,)
          ]),
    ); */
  }
}
