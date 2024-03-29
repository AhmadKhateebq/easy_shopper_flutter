import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Style/borders.dart';
import 'package:graduation_project/firebase_options.dart';
import 'package:graduation_project/providers/AppColorProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/customer/create_list.dart';
import 'Pages/login/login.dart';
import 'Pages/splash/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPreferencesManager.loadPrefs();
  var prefs = SharedPreferencesManager.sharedPrefences!;
  int appColorHex =  prefs.getInt("appColorHex")!=null ? prefs.getInt("appColorHex")!:-1;
  if(appColorHex!=-1){
  AppBorders.appColor = Color(appColorHex);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      // Hide the debug banner if desired
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: AppBorders.themeData,
    );
  }
}
