import 'package:flutter/material.dart';
import 'package:graduation_project/Pages/admin/admin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Style/borders.dart';
import '../customer/customer_main.dart';
import '../login/login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //in each app run check if the user is logged in or not
  String token = "";

  @override
  void initState() {
    super.initState();
    // Add any necessary initialization or data loading logic here
    // After a certain duration, navigate to the next screen
    Future.delayed(Duration(seconds: 3), () {
      SharedPreferences.getInstance().then((value) {
        token = value.getString("userToken") != null
            ? value.getString("userToken")!
            : "";
        print("userToken: " + token);
        if (token != "") {
          if (token == '1477') {
            print("route switched to main page");
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return AdminHomePage();
            }));
          } else {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return CustomerHomePage();
            }));
          }
        } else {
          print("route switched to login page");
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return Login();
          }));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 20),
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
      ),
    );
  }
}
