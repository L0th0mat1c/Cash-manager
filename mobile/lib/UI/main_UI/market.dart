import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapp/core/state_management/main_app_controller_provider.dart';
import 'package:mobileapp/core/user_secure_storage.dart';
import 'package:mobileapp/models/cart.dart';

class Market extends StatefulWidget {
  final MainAppControllerProvider consumer;

  Market({
    @required this.consumer,
  });

  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<Market> {
  String token;

  Future<Cart> getUserCart() async {
    try {
      final response = await http
          .get(Uri.parse('http://138.68.112.53/market/api/cart'), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${this.token}',
      });
      Cart data = Cart.fromJson(json.decode(response.body));
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> addProductinCart(int productId) async {
    try {
      final response = await http
          .post(
          Uri.parse('http://138.68.112.53/market/api/cart'), body: json.encode(
          {"product_id": productId}), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${this.token}',
      });
      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deleteProductinCart(int productId) async {
    try {
      final response = await http
          .delete(Uri.parse(
          'http://138.68.112.53/market/api/cart/products/${productId}'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${this.token}',
          });
      if (response.statusCode == 202) {
        return true;
      }
      print(response.body);
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

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

  Widget _titleCart(double width, double height) {
    return Container(
        width: width,
        height: height,
        alignment: Alignment.bottomCenter,
        child: new Text("Votre panier",
            style:
            GoogleFonts.nunito(fontSize: 27, fontWeight: FontWeight.w800)));
  }

  Widget _productInfo(CartProduct product, double width, double height) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        width: 100,
        height: 120,
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        child: Stack(
          children: [
            Positioned(
              top: 2,
              left: 2,
              child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(product.image_url),
                          fit: BoxFit.cover)),
                  height: height * 0.23,
                  width: width * 0.3),
            ),
            Positioned(
                top: 30,
                bottom: 30,
                right: 55,
                left: 115,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(product.name,
                      style: GoogleFonts.nunito(
                          fontSize: 15, fontWeight: FontWeight.w800)),
                )),
            Positioned(
                right: 12,
                top: 0,
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    var res = await addProductinCart(product.id);
                    if (res) {
                      setState(() {});
                    }
                  },
                )),
            Positioned(
                top: 40,
                bottom: 40,
                right: 15,
                child: Container(
                    alignment: Alignment.center,
                    width: 40,
                    child: Text("${product.quantity ?? 1}",
                        style: GoogleFonts.nunito(
                            fontSize: 15, fontWeight: FontWeight.w800)))),
            Positioned(
                right: 12,
                bottom: 0,
                child: IconButton(
                    icon: Icon(Icons.remove), onPressed: () async {
                  var res = await deleteProductinCart(product.id);
                  if (res) {
                    setState(() {});
                  }
                }))
          ],
        ));
  }

  Widget _productList(double width, double height, Cart cart) {
    return Container(
      width: width,
      height: height,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return;
        },
        child: ListView.builder(
          itemCount: cart.products.length,
          itemBuilder: (BuildContext context, int index) {
            return _productInfo(cart.products.elementAt(index), width, height);
          },
        ),
      ),
    );
  }

  Widget _cartUser(double width, double height, Cart cart) {
    double total = 0;

    cart.products.forEach((element) {
      total += element.total ?? 0;
    });

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return;
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            _titleCart(width * 0.97, height * 0.05),
            _productList(width * 0.97, height * 0.65, cart),
            if (cart.products.length > 0)
              Container(
                  width: width,
                  height: height * 0.1,
                  child: Stack(
                    children: [
                      Positioned(
                          left: 50,
                          right: 50,
                          child: Text("Total panier: ${total.toStringAsFixed(2)}€",
                              style: GoogleFonts.nunito(
                                  fontSize: 18, fontWeight: FontWeight.w800)))
                    ],
                  ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: getUserCart(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return _cartUser(width, height, snapshot.data);
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
