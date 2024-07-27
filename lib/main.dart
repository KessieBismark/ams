import 'package:ams/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'services/config/binding.dart';
import 'services/utils/themes.dart';

void main() async {
  await GetStorage.init();
  // ignore: unused_local_variable
  ThemeController themes = Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AMS',
        theme: darkTheme,
        initialBinding: AMSBinding(),
        darkTheme: darkTheme,
        // themeMode: ThemeMode.system,
        home: const Login());
  }
}
