import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imin/helpers/configs.dart';
import 'package:imin/models/login_model.dart';

Future requestRecoveryPasswordApi(String email) async {
  try {
    print('username:' + email);
    return await http.post(
      Uri.parse(ipServer + '/guard/recovery/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        "email": email,
        "url": "http://192.168.1.50:3000/guardhouse/recoverypassword/"
      }),
    );

    // print('response.statusCode: ${response.statusCode}');
    // print('response: ${response}');

    // print('username:' + email);
    // return true;
    // if (response.statusCode == 200) {
    //   return LoginModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    // } else {
    //   return false;
    // }
  } catch (e) {
    print("e: $e");
    return false;
  }
}
