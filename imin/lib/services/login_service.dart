import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imin/helpers/configs.dart';
import 'package:imin/models/login_model.dart';

Future loginApi(String user, String password) async {
  try {
    final response = await http.post(
      Uri.parse(ipServer + '/login_guard/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{
        "username": user,
        "password": password,
      }),
    );

    print('response.statusCode: ${response.statusCode}');
    // print(json.decode(response.body)['detail']);
    print(json.decode(utf8.decode(response.bodyBytes))['detail']);

    if (response.statusCode == 200) {
      return LoginModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      return response;
    }
  } catch (e) {
    print("e: $e");
    return "not call api";
  }
}
