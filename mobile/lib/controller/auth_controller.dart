import 'package:flutter/material.dart';
import 'package:mobileapp/UI/auth_UI/log_in.dart';
import 'package:mobileapp/UI/auth_UI/sign_up.dart';
import 'package:mobileapp/core/state_management/auth_controller_provider.dart';
import 'package:provider/provider.dart';

class AuthController extends StatefulWidget {
  @override
  _AuthControllerState createState() => _AuthControllerState();
}

class _AuthControllerState extends State<AuthController> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthControllerProvider>(
      create: (_) => AuthControllerProvider(),
      builder: (_, __) {
        return Scaffold(
          body: new Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.blue[100],
            child: new Consumer<AuthControllerProvider>(
              builder: (_, consumer, __) {
                return indexPage(consumer.getIndexPage);
              },
            ),
          ),
        );
      },
    );
  }

  Widget indexPage(int index) {
    switch (index) {
      case 0:
        return LogIn();
      case 1:
        return SignUp();
      default:
        return LogIn();
    }
  }
}
