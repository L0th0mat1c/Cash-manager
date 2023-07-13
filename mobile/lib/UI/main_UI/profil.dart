import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapp/core/state_management/main_app_controller_provider.dart';
import 'package:mobileapp/core/user_secure_storage.dart';

class Profil extends StatefulWidget {
  final MainAppControllerProvider consumer;

  Profil({
    @required this.consumer,
  });

  @override
  _ProfilState createState() => _ProfilState();
}
class _ProfilState extends State<Profil> {
  String token = '';

    Future<Map> getUser() async {
    try{
      final response = 
      await http.get(Uri.parse('http://138.68.112.53/market/api/user/me'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${this.token}',
      });
      Map<String, dynamic> data = json.decode(response.body);
      print(widget.consumer.getIndexPage);
      return data;
    }catch(e){
      print(e.toString());
      return {};
    }
  }

  @override
  void initState() {
    super.initState();

    init();
  }
  Future init() async {;
    final tokenStore = await UserSecureStorage.getToken() ?? '';
    setState(() {
      this.token = tokenStore;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    print(this.token);
    getUser();
    return Scaffold(
      body: FutureBuilder(
        future: getUser(),
        builder: (context, snap) {
          print(snap.data);
          final user = snap.data;
         
          if (snap.connectionState == ConnectionState.done && snap.hasData) {
            return ListView(
              physics: BouncingScrollPhysics(),
              children: [
                BuildName(user),
                const SizedBox(height: 24),
                Center(child:buildButton(widget.consumer)),
                const SizedBox(height:50),
                buildDetails(user)
              ],
            );
          }
          if(snap.hasError){
            return Column(children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snap.error}'),
              )
            ]);
            
          }
          return Center(child: CircularProgressIndicator());
        })
    );  
  }
  Widget BuildName(Map user) => Container(
    margin: const EdgeInsets.all(20),
    child:  Column(
    children: [
      Text('${user["username"]}' == null ? 'Non renseigné' : '${user["username"]}',
        style:  GoogleFonts.nunito(
                fontSize: 24,
                fontWeight: FontWeight.bold
      )),
      const SizedBox(height: 5),
      Text(user["email"] == null ? 'Non renseigné' : user["email"],
        style: GoogleFonts.nunito(
                color: Colors.grey
      )),
  ],
  )
    );
  
  Widget buildButton(consumer) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      shape: StadiumBorder(),
      onPrimary: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12)
    ),
    onPressed: (){
      consumer.setIndexPage(4);
    }, 
    child: Text("Modifier votre profil")
  );

  Widget buildDetails(user) => Container(
    margin: EdgeInsets.all(30),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Nom',
            style:  GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.bold
                )
      ),
          Text(user["last_name"] == null ? 'Non renseigné' : user["last_name"],
            style:  GoogleFonts.nunito(
                fontSize: 16,   
                )
      ),
      ]
      ),
      const SizedBox(height: 20),
       Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Prénom',
            style:  GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.bold
                )
      ),
          Text(user["first_name"] == null ? 'Non renseigné' : user["first_name"],
            style:  GoogleFonts.nunito(
                fontSize: 16,   
                )
      ),
      ]
      ),
      const SizedBox(height: 20),
      const SizedBox(height: 20),
       Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Date de naissance',
            style:  GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold
                )
      ),
          Text(user["birthday"] == null ? 'Non renseigné': user["birthday"],
            style:  GoogleFonts.nunito(
                fontSize: 16,   
                )
      ),
      ]
      ),
      
      
    ],
    )
    );
  
  
}
