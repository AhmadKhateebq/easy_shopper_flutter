import 'package:flutter/material.dart';

class AppBorders {
  static const double radius = 15;
  static Color appColor = Color(0xFFee1754);
  // static Color appColor = Color.fromARGB(255, 235, 148, 34);
  static ThemeData themeData = ThemeData(
      focusColor: appColor,
      primaryColor: appColor,
      textSelectionTheme: TextSelectionThemeData(
          cursorColor: appColor,
          selectionColor: appColor,
          selectionHandleColor: appColor),
      iconTheme: IconThemeData(color: appColor));

  static Decoration containerDecoration() {
    return BoxDecoration(
      color: Color.fromARGB(251, 255, 255, 255),
      border: Border.all(color: Colors.transparent),
      borderRadius: const BorderRadius.all(Radius.circular(radius)),
      boxShadow: const [
        BoxShadow(blurRadius: 8, color: Color.fromARGB(255, 145, 145, 145))
      ],
    );
  }

  static InputDecoration txtFieldDecoration(String label,
      {Icon? prefIcon, Widget? suffIcon}) {
    Color focusColor = appColor;
    return InputDecoration(
        floatingLabelStyle: TextStyle(color: focusColor),
        iconColor: focusColor,
        labelText: label,
        prefixIcon: prefIcon,
        suffixIcon: suffIcon,
        focusColor: focusColor,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appColor),
            borderRadius: const BorderRadius.all(Radius.circular(radius))),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(191, 216, 216, 216)),
            borderRadius: BorderRadius.all(Radius.circular(radius))),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFff3333)),
            borderRadius: BorderRadius.all(Radius.circular(radius))));
  }

  static InputDecoration passwordFieldDecoration(
      String label, Widget? suffIcon) {
    Color focusColor = appColor;
    return InputDecoration(
        floatingLabelStyle: TextStyle(color: focusColor),
        iconColor: focusColor,
        labelText: label,
        suffixIcon: suffIcon,
        focusColor: focusColor,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appColor),
            borderRadius: const BorderRadius.all(Radius.circular(radius))),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(191, 216, 216, 216)),
            borderRadius: BorderRadius.all(Radius.circular(radius))),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFff3333)),
            borderRadius: BorderRadius.all(Radius.circular(radius))));
  }

  static ButtonStyle btnStyle({Color? btnColor}) {
    return ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(btnColor == null ? appColor : btnColor),
        shape: MaterialStateProperty.all(const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(AppBorders.radius)))));
  }
}
