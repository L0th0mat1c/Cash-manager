import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mobileapp/core/state_management/main_app_controller_provider.dart';
import 'package:mobileapp/widget/custome_snack_bar.dart';
import 'package:mobileapp/widget/product_list.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapp/models/product.dart';
import 'package:mobileapp/core/user_secure_storage.dart';
import 'package:mobileapp/widget/top_snack_bar.dart';
class Home extends StatefulWidget {
  final MainAppControllerProvider consumer;

  Home({
    @required this.consumer,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String token = '';
    @override
  void initState() {
    super.initState();

    init();
  }
  Future init() async {
    final tokenStore = await UserSecureStorage.getToken() ?? '';
    setState(() {
      this.token = tokenStore;
    });
  }
  Future<List<Product>> getCatalog() async {
    try{
      final response = 
      await http.get(Uri.parse('http://138.68.112.53/market/api/catalog'));
      var data = json.decode(response.body);
      Iterable it = data["catalog"];
      var products = it.map((e) => Product.fromJson(e)).toList();
      return products;
    }catch(e){
      showTopSnackBar(
        context,
        CustomSnackBar.error(
            message: "Erreur serveur: Impossible de récupérer le catalog"),
      );
      return [];
    }
  }



  Widget build(BuildContext context) => Scaffold(
    // appBar: MyAppBar(),
      body: FutureBuilder<List<Product>>(
        future: getCatalog(),
        builder: (context, snap) {
          final products = snap.data;
          if (snap.connectionState == ConnectionState.done && snap.hasData) {
            return home(products);
          }
          return Center(child: CircularProgressIndicator());
        }
        )
      );
  

      Widget home(List<Product> products) => GridView.builder(
      gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      physics: BouncingScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductList(product, token);
      },
      
      
    );
    
  }

