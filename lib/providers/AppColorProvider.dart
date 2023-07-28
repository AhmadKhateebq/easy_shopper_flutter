import 'package:flutter/material.dart';
import 'package:graduation_project/Style/borders.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SharedPreferencesManager {
  static SharedPreferences? sharedPrefences;
  static loadPrefs ()async{
    sharedPrefences = await SharedPreferences.getInstance();
    print("prefernces loaded");
  }
}
class AppColorProvider extends ChangeNotifier{
  Color _appColor = Color(0xFFee1754);
  AppColorProvider(){
    if(SharedPreferencesManager.sharedPrefences!=null){
      int appColorHex =  SharedPreferencesManager.sharedPrefences!.getInt("appColorHex")!=null ?SharedPreferencesManager.sharedPrefences!.getInt("appColorHex")!:-1;
      print("hex code shared prefs : ${appColorHex.toRadixString(16)}");
      if(appColorHex!=-1){
        _appColor = Color(appColorHex);
        AppBorders.appColor = _appColor;
      }
    }

  }

  Color get appColor => _appColor;
  setAppColor(Color color)async{
    _appColor = color;
   var prefs = await SharedPreferences.getInstance();
   String colorHex = "0xff" +color.value.toRadixString(16);
   prefs.setInt("appColorHex",int.parse(colorHex));
   AppBorders.appColor = color;
   super.notifyListeners();
  }

}