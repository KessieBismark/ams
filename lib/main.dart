import 'package:ams/pages/login/login.dart';
import 'package:ams/widgets/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:system_theme/system_theme.dart';
import 'services/config/binding.dart';
import 'services/config/routes.dart';
import 'services/utils/themes.dart';

void main() async {
  await GetStorage.init();
  ThemeController themes = Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return fluent.FluentTheme(
      data: fluent.FluentThemeData(
        accentColor: fluent.AccentColor.swatch({
          'darkest': SystemTheme.accentColor.darkest,
          'darker': SystemTheme.accentColor.darker,
          'dark': SystemTheme.accentColor.dark,
          'normal': SystemTheme.accentColor.accent,
          'light': SystemTheme.accentColor.light,
          'lighter': SystemTheme.accentColor.lighter,
          'lightest': SystemTheme.accentColor.lightest,
        }),
        visualDensity: VisualDensity.standard,
        focusTheme: fluent.FocusThemeData(
          glowFactor: fluent.is10footScreen() ? 2.0 : 0.0,
        ),
      ),
      child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AMS',
           theme: lightTheme,
          initialBinding: AMSBinding(),
          //  darkTheme: darkTheme,
          // getPages: Routes.routes,
          // themeMode: ThemeMode.light,
          // initialRoute: '/auth',
          home: const Login()
          // defaultTransition: Transition.fadeIn,
          ),
    );
  }
}
