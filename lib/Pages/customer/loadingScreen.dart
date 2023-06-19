import 'package:flutter/material.dart';
import 'package:graduation_project/Style/borders.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Simulating a delay to show the loading screen
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
          context, '/map'); // Navigate to the main page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppBorders.appColor,
      body: Center(
        child: CircularProgressIndicator(), // Loading indicator widget
      ),
    );
  }
}
