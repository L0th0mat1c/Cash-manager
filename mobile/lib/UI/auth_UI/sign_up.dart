import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:mobileapp/core/state_management/auth_controller_provider.dart';
import 'package:mobileapp/widget/bezierContainer.dart';
import 'package:provider/provider.dart';

import 'log_in.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Consumer<AuthControllerProvider>(
      builder: (_, consumer, __) {
        return Scaffold(
            body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -MediaQuery.of(context).size.height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      SizedBox(
                        height: 50,
                      ),
                      _emailPasswordWidget(consumer),
                      SizedBox(
                        height: 20,
                      ),
                      _submitButton(consumer),
                      // SizedBox(height: height * .14),
                      _loginAccountLabel(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
      },
    );
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton(AuthControllerProvider consumer) {
    return new AbsorbPointer(
      absorbing: consumer.getBoolSignUp,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: consumer.getBoolSignUp
            ? new CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
            : TextButton(
                child: Text(
                  'Register Now',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onPressed: () {
                  consumer.signUp(context);
                },
              ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return Consumer<AuthControllerProvider>(
      builder: (_, consumer, __) {
        return InkWell(
          onTap: () {
            consumer.setIndexPage(0);
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            padding: EdgeInsets.all(15),
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Already have an account ?',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Login',
                  style: TextStyle(
                      color: Color(0xfff79c4f),
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'C',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffe46b10)),
          children: [
            TextSpan(
              text: 'ash',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'Manager',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget(AuthControllerProvider consumer) {
    return Column(
      children: <Widget>[
        _entryField("First Name", consumer.getFirstNameForSignUp),
        _entryField("Last Name", consumer.getLastNameForSignUp),
        _entryField("Username", consumer.getUsernameForSignUp),
        _entryField("Email", consumer.getEmailForSignUp),
        _entryField("Password", consumer.getPasswordForSignUp,
            isPassword: true),
      ],
    );
  }
}
