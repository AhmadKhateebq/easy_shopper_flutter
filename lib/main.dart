import 'package:flutter/material.dart';

// import 'Pages/customer/google_map_page.dart';
// import 'Pages/customer/list_page.dart';
// import 'Pages/customer/loadingScreen.dart';
import 'Pages/customer/create_list.dart';
import 'Pages/customer/customer_main.dart';
import 'Pages/login/login.dart';
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
      routes: {
        '/login': (context) => Login(),
        '/add-list': (context) => CreateListScreen(),
        // '/customer_main': (context) => CustomerHomePage(),
        //  '/': (context) => const LoadingScreen(),
        // '/map': (context) => const GoogleMapPage(),
      },
    );
  }
}
