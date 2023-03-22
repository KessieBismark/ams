import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/color.dart';

class ThemeController extends GetxController {
  BuildContext? context;
  final _isLightTheme = false.obs;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  saveThemeStatus() async {
    SharedPreferences pref = await _prefs;
    pref.setBool('theme', _isLightTheme.value);
  }

  _getThemeStatus() async {
    var isLight = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool('theme') ?? true;
    }).obs;
    _isLightTheme.value = await isLight.value;
    Get.changeThemeMode(_isLightTheme.value ? ThemeMode.light : ThemeMode.dark);
  }

  @override
  void onInit() {
    _getThemeStatus();
    super.onInit();
  }
}

ThemeData lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: mygrey,
  canvasColor: mygrey,
 // useMaterial3: true,
  //  buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),

  textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: dark),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder()
  }),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: dark,
//useMaterial3: true,
 // buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
 
  textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: light),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder()
  }),
);
