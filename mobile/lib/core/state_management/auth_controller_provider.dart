import 'dart:convert';
import 'package:mobileapp/core/user_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/core/route/constant.dart';
import 'package:mobileapp/widget/custome_snack_bar.dart';
import 'package:mobileapp/widget/top_snack_bar.dart';
import 'package:http/http.dart' as http;

class AuthControllerProvider extends ChangeNotifier {
  int _indexPage = 0;
  bool _loadingSignUp = false;
  bool _loadingSignIn = false;

  TextEditingController _emailForSignIn = new TextEditingController();
  TextEditingController _passwordForSignIn = new TextEditingController();
  TextEditingController _lastNameForSignUp = new TextEditingController();
  TextEditingController _firstNameForSignUp = new TextEditingController();
  TextEditingController _usernameForSignUp = new TextEditingController();
  TextEditingController _emailForSignUp = new TextEditingController();
  TextEditingController _passwordForSignUp = new TextEditingController();

  void setIndexPage(int index) {
    _indexPage = index;
    notifyListeners();
  }

  void signIn(BuildContext context) async {
    _loadingSignIn = true;
    notifyListeners();
    String email = _emailForSignIn.text.trim();
    String password = _passwordForSignIn.text.trim();
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        print("TRY");
        await http
            .post(Uri.http('138.68.112.53', '/market/api/auth/login'),
                body: json.encode({"email": email, "password": password}))
            .then((http.Response res) async {
          if (res.statusCode == 201) {
            // Map<String, dynamic> temp = json.decode(res.body);
            var result = json.decode(res.body);
            UserSecureStorage.setToken(result["access_token"]);
            Navigator.pushReplacementNamed(context, MAIN_APP_CONTROLLER_PATH);
          } else {
            _loadingSignIn = false;
            notifyListeners();
            return showTopSnackBar(
              context,
              CustomSnackBar.error(message: "Erreur veuillez recommencer"),
            );
          }
        });
      } catch (e) {
        _loadingSignIn = false;
        notifyListeners();
        return showTopSnackBar(
          context,
          CustomSnackBar.error(message: "Erreur réseau"),
        );
      }
    } else {
      _loadingSignIn = false;
      notifyListeners();
      return showTopSnackBar(
        context,
        CustomSnackBar.error(message: "Veuillez rentrer tous les chmamps"),
      );
    }
  }

  void signUp(BuildContext context) async {
    _loadingSignUp = true;
    notifyListeners();
    String username = _usernameForSignUp.text.trim();
    String email = _emailForSignUp.text.trim();
    String password = _passwordForSignUp.text.trim();
    String lastName = _lastNameForSignUp.text.trim();
    String firstName = _firstNameForSignUp.text.trim();

    if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
      try {
        await http
            .post(Uri.http('138.68.112.53', '/market/api/auth/register'),
                body: json.encode({
                  "email": email,
                  "first_name": firstName,
                  "last_name": lastName,
                  "password": password,
                  "username": username
                }))
            .then((http.Response res) {
          print(res.body);
          if (res.statusCode == 201) {
            // Map<String, dynamic> temp = json.decode(res.body);
          } else {
            _loadingSignUp = false;
            notifyListeners();
            return showTopSnackBar(
              context,
              CustomSnackBar.error(message: "Erreur veuillez recommencer"),
            );
          }
        });
      } catch (e) {
        _loadingSignUp = false;
        notifyListeners();
        return showTopSnackBar(
          context,
          CustomSnackBar.error(message: "Erreur Réseau"),
        );
      }
    } else {
      _loadingSignUp = false;
      notifyListeners();
      return showTopSnackBar(
        context,
        CustomSnackBar.error(
            message: "Veuillez remplir tous les champs demandés."),
      );
    }
  }

  void getAuthError(dynamic e, BuildContext context) {
    switch (e.code.toUpperCase()) {
      case "INVALID-EMAIL":
        return showTopSnackBar(
          context,
          CustomSnackBar.error(
              message: "Your email address appears to be malformed."),
        );
      case "WRONG-PASSWORD":
        return showTopSnackBar(
          context,
          CustomSnackBar.error(message: "Your password is wrong."),
        );
      case "USER-NOT-FOUND":
        return showTopSnackBar(
          context,
          CustomSnackBar.error(message: "User with this email doesn't exist."),
        );
      case "USER-DISABLED":
        return showTopSnackBar(
          context,
          CustomSnackBar.error(
              message: "User with this email has been disabled."),
        );
      case "TOO-MANY-REQUESTS":
        return showTopSnackBar(
          context,
          CustomSnackBar.error(message: "Too many requests. Try again later."),
        );
      case "OPERATION-NOT_ALLOWED":
        return showTopSnackBar(
          context,
          CustomSnackBar.error(
              message: "Signing in with email and Password is not enabled."),
        );
      default:
        return showTopSnackBar(
          context,
          CustomSnackBar.error(message: "An undefined error happened."),
        );
    }
  }

  TextEditingController get getEmailForSignIn => _emailForSignIn;

  TextEditingController get getPasswordForSignIn => _passwordForSignIn;

  TextEditingController get getFirstNameForSignUp => _firstNameForSignUp;

  TextEditingController get getLastNameForSignUp => _lastNameForSignUp;

  TextEditingController get getUsernameForSignUp => _usernameForSignUp;

  TextEditingController get getEmailForSignUp => _emailForSignUp;

  TextEditingController get getPasswordForSignUp => _passwordForSignUp;

  int get getIndexPage => _indexPage;

  bool get getBoolSignUp => _loadingSignUp;

  bool get getBoolSignIn => _loadingSignIn;
}
