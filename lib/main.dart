import 'package:flutter/material.dart';

import 'Pages/splash/splash.dart';

void main() {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Hide the debug banner if desired
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
