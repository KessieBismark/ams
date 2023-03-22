import 'package:ams/services/config/binding.dart';
import 'package:ams/services/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'services/utils/themes.dart';

void main() async {
  await GetStorage.init();
  ThemeController themes = Get.put(ThemeController());
  AMSBinding allBinding = Get.put(AMSBinding());
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
      darkTheme: darkTheme,
      getPages: Routes.routes,
      themeMode: ThemeMode.dark,
      initialRoute: '/auth',
      defaultTransition: Transition.fadeIn,
    );
  }
}
