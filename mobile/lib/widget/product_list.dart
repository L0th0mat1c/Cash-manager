import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapp/widget/custome_snack_bar.dart';
import 'dart:convert';
import 'package:mobileapp/widget/top_snack_bar.dart';


class ProductList extends StatelessWidget {
  final productData;
  final token;
  const ProductList(this.productData, this.token);

    void addToMarket(BuildContext context, int id) async {
    print(id);
    if (id != null) {
      try {

        print(token);
        print("TRY");
        await http
            .post(Uri.http('138.68.112.53', '/market/api/cart'),
            headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${token}',
            },
            body: json.encode({"product_id": id}))
            .then((http.Response res) async {
          if (res.statusCode == 201) {   
            showTopSnackBar(
              context,
              CustomSnackBar.success(
                  message: "Votre a poduit a été ajouté !"),
            ); 
          } else {
            print(res.statusCode);
          if (res.statusCode == 400) {
            showTopSnackBar(
              context,
              CustomSnackBar.error(
                  message: "Erreur ${res.statusCode}: Not found"),
            );
          }
          if(res.statusCode == 403){
            showTopSnackBar(
              context,
              CustomSnackBar.error(
                message: "Erreur ${res.statusCode}: Non autorisé"),
            );
          }
          }
        });
      } catch (e) {
        print(e);
        return showTopSnackBar(
        context,
        CustomSnackBar.error(
            message: "Erreur $e: Impossible de récupérer le catalog"),
      );
      }
    } 
  }
  @override
  Widget build(BuildContext context) {
    print(productData);
    var container = Container(
          height: 110,
          decoration:  BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            image: DecorationImage(
              image: NetworkImage(productData.image_url
            ),
            fit: BoxFit.cover,
            )
          ),
          
        );
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(18),
          
        ),
        boxShadow: [ 
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 4,
            blurRadius: 6,
            offset: Offset(0, 3)
        
          ),
          ],
      ),
      child: Stack(
            alignment: Alignment.center,
            children: [
              Column(children: [
              container,
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      productData.name.length > 13 ? '${productData.name.substring(0,13)}...' : productData.name,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.w800
                      )
                    ),
                    Text(
                      productData.price.toString() + ' €',
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        fontWeight: FontWeight.w800
                      )
                    )

                  ]
                  )
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Origine: ' + productData.origin,
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w800
                      )
                      ),
                    ]
                  ),
                  
                ),
            ],),
                Positioned(
                  top: 80,
                  child: MaterialButton(
                    color: Colors.white,
                    shape: const CircleBorder(
                      side: BorderSide(color: Colors.black)
                    ),
                    onPressed: (){
                      addToMarket(context, productData.id);
                    },
                    child: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.black,
                      size: 23
                    )
                    ))
              ]
            )
        );
  }


}