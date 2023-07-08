import 'package:flutter/material.dart';
import 'package:graduation_project/Style/borders.dart';

class LoadingScreen2 extends StatefulWidget {
  const LoadingScreen2({Key? key}) : super(key: key);

  @override
  _LoadingScreen2State createState() => _LoadingScreen2State();
}

class _LoadingScreen2State extends State<LoadingScreen2> {
  @override
  void initState() {
    super.initState();
    // Simulating a delay to show the loading screen
    Future.delayed(Duration(seconds: 2), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: CircleAvatar(
                  backgroundColor: AppBorders.appColor,
                  radius: MediaQuery.of(context).size.width * 0.15,
                  child: Image.asset(
                    "lib/Assets/Images/cart.png",
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(),
            ],
          ),
        ));
  }
}
