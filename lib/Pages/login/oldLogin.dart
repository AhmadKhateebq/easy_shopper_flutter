// import 'package:flutter/material.dart';
// import 'package:graduation_project/Apis/LoginApis.dart';
// import 'package:graduation_project/Pages/Regestration/userInfo.dart';
// import 'package:graduation_project/Pages/admin/admin_page.dart';
// import 'package:graduation_project/Style/borders.dart';
// import 'package:graduation_project/customer/list_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../customer/customer_main.dart';
//
// class Login extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return MaterialApp(
//       theme: AppBorders.themeData,
//       home: LoginHome(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class LoginHome extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _LoginHomeState();
//   }
// }
//
// class _LoginHomeState extends State<LoginHome> {
//   showAlert(String msg) {
//     showDialog(
//         context: context,
//         builder: (alertContext) {
//           return AlertDialog(
//             content: Text(msg),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.of(alertContext).pop();
//                   },
//                   child: Text(
//                     "OK",
//                     style: TextStyle(color: AppBorders.appColor),
//                   ))
//             ],
//           );
//         });
//   }
//
//   TextEditingController usernameCont = TextEditingController();
//   TextEditingController passwordCont = TextEditingController();
//   bool isLoading = false;
//   @override
//   Widget build(BuildContext context) {
//     MediaQueryData mediaQueryData = MediaQuery.of(context);
//     double screenWidth = mediaQueryData.size.width;
//     double screenHeight = mediaQueryData.size.height;
//
//     return Scaffold(
//         backgroundColor: Color.fromARGB(255, 229, 229, 229),
//         body: SingleChildScrollView(
//           child: Container(
//               width: double.infinity,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(top: 20),
//                     decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 3)),
//                     child: CircleAvatar(
//                         backgroundColor: AppBorders.appColor,
//                         radius: screenWidth * 0.15,
//                         child: Image.asset(
//                           "lib/Assets/Images/cart.png",
//                           width: screenWidth * 0.15,
//                           height: screenHeight * 0.15,
//                         )),
//                   ),
//                   Container(
//                     alignment: Alignment.center,
//                     width: double.infinity,
//                     padding: EdgeInsets.all(screenWidth * 0.05),
//                     margin: EdgeInsets.all(screenWidth * 0.05),
//                     decoration: AppBorders.containerDecoration(),
//                     child: Column(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(bottom: screenHeight * 0.03),
//                           child: TextFormField(
//                             controller: usernameCont,
//                             decoration: AppBorders.txtFieldDecoration(
//                                 "Username",
//                                 prefIcon: Icon(Icons.person)),
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.only(bottom: screenHeight * 0.03),
//                           child: TextFormField(
//                               controller: passwordCont,
//                               obscureText: true,
//                               decoration: AppBorders.txtFieldDecoration(
//                                 "Password",
//                                 prefIcon: const Icon(Icons.lock),
//                               )),
//                         ),
//                         SizedBox(
//                             width: double.infinity,
//                             height: screenHeight * 0.07,
//                             child: ElevatedButton.icon(
//                               onPressed: isLoading
//                                   ? null
//                                   : () {
//                                 var username = usernameCont.text,
//                                     password = passwordCont.text;
//
//                                 if (username.isEmpty ||
//                                     password.isEmpty) {
//                                   showAlert("Empty username or password");
//                                   return;
//                                 }
//                                 setState(() {
//                                   isLoading = true;
//                                 });
//                                 LoginApis.login(username, password)
//                                     .then((value) {
//                                   String response = value.body;
//                                   print("login response: " +
//                                       response +
//                                       "status ${value.statusCode}");
//                                   print(value.statusCode);
//                                   if (value.statusCode == 200 ||
//                                       value.statusCode == 201) {
//                                     //store token in the session
//
//                                     SharedPreferences.getInstance()
//                                         .then((prefs) {
//                                       prefs.setString(
//                                           "userToken", response);
//                                       if (response == "1477") {
//                                         Navigator.of(context)
//                                             .pushReplacement(
//                                             MaterialPageRoute(
//                                                 builder: (context) {
//                                                   return AdminHomePage();
//                                                 }));
//                                       } else {
//                                         Navigator.of(context)
//                                             .pushReplacement(
//                                             MaterialPageRoute(
//                                                 builder: (context) {
//                                                   return CustomerHomePage();
//                                                 }));
//                                       }
//                                       /* prefs.setString(
//                                                 "adminAuth", "Bearer 1447"); */
//                                     });
//                                   } else if (value.statusCode == 418) {
//                                     showAlert(
//                                         "Wrong username or password");
//                                     ;
//                                     setState(() {
//                                       isLoading = false;
//                                     });
//                                   } else {
//                                     showAlert("Something went wrong");
//                                     setState(() {
//                                       isLoading = false;
//                                     });
//                                   }
//                                 });
//                               },
//                               icon: isLoading
//                                   ? CircularProgressIndicator(
//                                 color: Colors.white,
//                               )
//                                   : Icon(
//                                 Icons.login,
//                                 size: screenWidth * 0.07,
//                               ),
//                               label: Text("Login",
//                                   style:
//                                   TextStyle(fontSize: screenWidth * 0.05)),
//                               style: AppBorders.btnStyle(),
//                             )),
//                         /*     SizedBox(
//                           child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Text("Dont have an account?"),
//                           TextButton(
//                               onPressed: () {
//                                 Navigator.push(context,
//                                     MaterialPageRoute(builder: (context) {
//                                   return UserInfo();
//                                 }));
//                               },
//                               child: Text(
//                                 "Create Account",
//                                 style: TextStyle(color: AppBorders.appColor),
//                               ))
//                         ],
//                       )) */
//                       ],
//                     ),
//                   ),
//                 ],
//               )),
//         ));
//   }
// }
////////////////////////////////////////////////////////