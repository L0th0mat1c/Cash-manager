import 'package:flutter/material.dart';
import 'package:mobileapp/UI/main_UI/home.dart';
import 'package:mobileapp/UI/main_UI/market.dart';
import 'package:mobileapp/UI/main_UI/profil.dart';
import 'package:mobileapp/UI/main_UI/scan.dart';
import 'package:mobileapp/UI/main_UI/edit_profil.dart';
import 'package:mobileapp/core/state_management/main_app_controller_provider.dart';
import 'package:provider/provider.dart';

class MainAppController extends StatefulWidget {
  @override
  _MainAppControllerState createState() => _MainAppControllerState();
}

class _MainAppControllerState extends State<MainAppController> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainAppControllerProvider>(
      create: (_) => MainAppControllerProvider(),
      builder: (_, __) {
        return new Consumer<MainAppControllerProvider>(
          builder: (_, consumer, __) {
            return Scaffold(
              appBar: myAppBar(consumer.getIndexPage, consumer),
              body: new Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.orange[100],
                child: indexPage(consumer.getIndexPage, consumer),
              ),
              bottomNavigationBar: BottomNavigationBar(
                // fixedColor: Colors.red,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.qr_code_scanner),
                    label: 'Scan',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle),
                    label: 'Profil',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add_shopping_cart),
                    label: 'Card',
                  ),
                ],
                currentIndex: displayPage(consumer),
                selectedItemColor: Colors.amber[800],
                unselectedItemColor: Colors.green,
                onTap: consumer.setIndexPage,
              ),
            );
          },
        );
      },
    );
  }

  int displayPage(MainAppControllerProvider consumer) {
    int index = consumer.getIndexPage;
    if (index < 4) {
      return index;
    } else {
      return 2;
    }
  }

  Widget indexPage(int index, MainAppControllerProvider consumer) {
    switch (index) {
      case 0:
        return Home(consumer: consumer);
      case 1:
        return Scan(consumer: consumer);
      case 2:
        return Profil(consumer: consumer);
      case 3:
        return Market(consumer: consumer);
      case 4:
        return EditProfil(consumer: consumer);
      default:
        return Home(consumer: consumer);
    }
  }

  Widget myAppBar(int index, MainAppControllerProvider consumer) {
    switch (index) {
      case 0:
        return AppBar(
          backgroundColor: Colors.amber[800],
          title: Text("Home"),
          actions: [
            GestureDetector(
              onTap: () {
                consumer.setIndexPage(3);
              },
              child: Icon(Icons.add_shopping_cart),
            )
          ],
        );
      case 1:
        return AppBar(
          backgroundColor: Colors.amber[800],
          title: Text("Scan"),
        );

      case 2:
        return AppBar(
          backgroundColor: Colors.amber[800],
          title: Text("Profil"),
          actions: [
            GestureDetector(
              onTap: () {
                consumer.setIndexPage(3);
              },
              child: Icon(Icons.add_shopping_cart),
            )
          ],
        );

      case 3:
        return AppBar(
          backgroundColor: Colors.amber[800],
          title: Text("Card"),
        );

      case 4:
        return AppBar(
          backgroundColor: Colors.amber[800],
          title: Text("Mettre à jour le profil"),
        );

      default:
        return AppBar(
          backgroundColor: Colors.amber[800],
          title: Text("Home"),
        );
    }
  }
}
