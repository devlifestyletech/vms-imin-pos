import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:imin/views/screens/ChangePassword/change_password_screen.dart';
import 'package:imin/views/screens/Login/login_screen.dart';
import 'package:imin/views/screens/Profile/demo.dart';
import 'package:imin/views/screens/Profile/profile_screen.dart';

void main() {
  runApp(MyApp());

  // Hide status bar and bottom navigation bar
  SystemChrome.setEnabledSystemUIOverlays([]);
  // Lock Screen Orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'VMS Dashboard Status',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/change_password',
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/profile', page: () => ProfileScreen()),
        GetPage(name: '/change_password', page: () => ChangePasswordScreen()),

        // demo
        GetPage(name: '/demo', page: () => ExpansionPanelDemo()),
      ],
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key}) : super(key: key);

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   static const platform = MethodChannel('samples.flutter.dev/battery');
//   // Get battery level.
//   String _batteryLevel = 'Unknown battery level.';

//   Future<void> _getBatteryLevel() async {
//     String batteryLevel;
//     try {
//       final int result = await platform.invokeMethod('getBatteryLevel');
//       batteryLevel = 'Battery level at $result % .';
//     } on PlatformException catch (e) {
//       batteryLevel = "Failed to get battery level: '${e.message}'.";
//     }

//     setState(() {
//       _batteryLevel = batteryLevel;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton(
//               child: Text('Get Battery Level'),
//               onPressed: _getBatteryLevel,
//             ),
//             Text(_batteryLevel),
//           ],
//         ),
//       ),
//     );
//   }
// }
