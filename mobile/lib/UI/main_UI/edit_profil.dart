import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/core/state_management/main_app_controller_provider.dart';
import 'package:mobileapp/core/user_secure_storage.dart';
import 'package:mobileapp/widget/custome_snack_bar.dart';
import 'package:mobileapp/widget/textfield_widget.dart';
import 'package:mobileapp/widget/top_snack_bar.dart';

class EditProfil extends StatefulWidget {
    final MainAppControllerProvider consumer;

  EditProfil({
    @required this.consumer,
  });
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfil> {
  String token = '';
  Map user;
  final _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

    @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }
    Future<Map> getUser() async {
    try{
      print('ok $token');
      final response = 
      await http.get(Uri.parse('http://138.68.112.53/market/api/user/me'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${this.token}',
      });
      print(response.body);
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        this.user = data;
      });
      return data;
    }catch(e){
      print(e.toString());
      return {};
    }
  }

  Future putUser() async {
    try{
      print('ok ${json.encode(user)}');
      await http.put(Uri.parse('http://138.68.112.53/market/api/user'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${this.token}',
      },
      body: json.encode(user)).then((http.Response res) async {
        print(res.statusCode);
        if(res.statusCode == 202) {
          showTopSnackBar(
              context,
              CustomSnackBar.success(
                  message: "Votre compte a été modifié !"),
            );
        } else {
            showTopSnackBar(
              context,
              CustomSnackBar.error(
                  message: "Erreur ${res.statusCode}: Not found"),
            );
         
        }
      });
    }catch(e){
      print(e.toString());
      return e;
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }
  Future init() async {
    final tokenStore = await UserSecureStorage.getToken() ?? '';
    await setState(() {
      this.token = tokenStore;
    });
    await getUser();
  }
    @override
  Widget build(BuildContext context) {
    print('test ${user}');
    if(user != null) {
  return Form(
          key: _formKey,
          child: Container(
            color: Colors.white,
            child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 32),
               
                  physics: BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 50),
                    TextFieldWidget(
                      label: "Nom",
                      text: user["last_name"] == null ? '' : user["last_name"],
                      onChanged: (last_name) {
                        setState(() {
                          this.user["last_name"] = last_name;
                        });
                        print(last_name);}
                    ),
                    const SizedBox(height: 20),
                    TextFieldWidget(
                      label: "Prénom",
                      text: user["first_name"] == null ? '': user["first_name"],
                      onChanged: (first_name) {
                        setState(() {
                          this.user["first_name"] = first_name;
                        });
                      }
                    ),
                    const SizedBox(height: 20),
                    TextFieldWidget(
                      label: "Email",
                      text: user["email"] == null ? '': user["email"],
                      onChanged: (email) {
                        setState(() {
                          this.user["email"] = email;
                        });
                      }
                    ),
                    const SizedBox(height: 20),
                    TextFieldWidget(
                      label: "Pseudo",
                      text: user["username"] == null ? '': user["username"],
                      onChanged: (username) {
                        setState(() {
                          this.user["username"] = username;
                        });
                      }
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            primary: Colors.red,
                            shadowColor: Colors.red[100],
                            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12)
                          ),
                          onPressed: (){
                            widget.consumer.setIndexPage(2);
                          }, 
                          child: Text("Annuler", style: GoogleFonts.nunito(
                            fontSize: 16,
                            ))
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            shadowColor: Colors.red[100],
                            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12)
                          ),
                          onPressed: (){
                              print(user);
                              putUser();
                              widget.consumer.setIndexPage(2);
                          }, 
                          child: Text("Sauvegarder", style: GoogleFonts.nunito(
                            fontSize: 16,
                            ))
                        ),
                    ])
                  ],
                )
          )
          
          
        );
        }else 
        return Center(child: CircularProgressIndicator());
        
        }
        
              }


