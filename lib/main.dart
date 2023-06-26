import 'package:ams/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'services/config/binding.dart';
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
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AMS',
        theme: lightTheme,
        initialBinding: AMSBinding(),
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: const Login());
  }
}
