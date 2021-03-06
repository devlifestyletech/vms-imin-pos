import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:imin/helpers/configs.dart';

Future checkInApi(
    String listStatus,
    String listId,
    String homeId,
    String dateIn,
    String token,
    String firstname,
    String lastname,
    String license_plate,
    qr_gen_id) async {
  try {
    print('listStatus $listStatus');
    print('listId $listId');
    print('homeId $homeId');
    print('dateIn $dateIn');
    // return true;
    final response = await http.post(
      Uri.parse(ipServer + '/guardhouse_checkin/'),
      headers: <String, String>{
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(<String, String>{
        "classname": listStatus,
        "class_id": listId,
        "home_id": homeId,
        "datetime_in": dateIn,
        "firstname": firstname,
        "lastname": lastname,
        "license_plate": license_plate,
        "qr_gen_id": qr_gen_id,
      }),
    );

    print('response.statusCode: ${response.statusCode}');

    if (response.statusCode == 200) {
      return true;
    } else {
      // throw Exception('Failed to load Profile');
      return false;
    }
  } catch (e) {
    print("e: $e");
    return false;
  }
}
