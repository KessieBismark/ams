
import 'package:get/get.dart';

import 'users_controller.dart';

class Userbind implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UsersController());
  }
}
