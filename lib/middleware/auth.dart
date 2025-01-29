import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smei_workspace/main.dart';

class AuthMiddleware extends GetMiddleware  {
  SharedPreferences get _pref => Get.find();

  @override
  RouteSettings? redirect(String? route) {
    if(_pref.get('loggedIn') != null && route != Routes.home.routeName) {
      return RouteSettings(name: Routes.home.routeName, arguments: Get.arguments);
    }
    return null;
  }
}