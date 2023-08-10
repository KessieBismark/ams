import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/server.dart';

class Query {
  static Future queryData(var query) async {
    try {
      var res = await http.post(Uri.parse(Api.url), body: query);
      if (res.statusCode == 200) {
        return res.body;
      } else {
        print.call(res.body);
        return "false";
      }
    } catch (e) {
      print.call(e);
      return null;
    }
  }

  static Future login(var query) async {
    try {
      var res = await http.post(Uri.parse(Api.url), body: query);
      if (res.statusCode == 200 && jsonDecode(res.body) != 'false') {
        return res.body;
      } else {
        return jsonEncode('false');
      }
    } catch (e) {
      print.call(e);
      return null;
    }
  }

  static Future getValue(var query) async {
    try {
      var res = await http.post(Uri.parse(Api.url), body: query);
      if (res.statusCode == 200) {
        print.call(res.body);
        return res.body;
      } else {
        return "false";
      }
    } catch (e) {
      print.call(e);
      return null;
    }
  }



  static Future recordCount(var query) async {
    try {
      var res = await http.post(Uri.parse(Api.url), body: query);
      if (res.statusCode == 200) {
        return res.body;
      } else {
        return "false";
      }
    } catch (e) {
      print.call(e);
      return null;
    }
  }

  static Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
