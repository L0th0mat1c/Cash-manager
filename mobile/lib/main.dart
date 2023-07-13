/* Flutter & Dart */
import 'package:flutter/material.dart';

/* Externql Widget */

/* Internql Widget */
import 'controller/auth_controller.dart';
import 'core/route/route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (settings) => onGenerateRoute(settings),
      home: AuthController(),
    );
  }
}
