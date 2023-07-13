import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/core/state_management/auth_controller_provider.dart';
import 'package:mobileapp/core/state_management/main_app_controller_provider.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:mobileapp/core/user_secure_storage.dart';

class Scan extends StatefulWidget {
  final MainAppControllerProvider consumer;

  Scan({
    @required this.consumer,
  });

  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MainAppControllerProvider>(builder: (_, consumer, __) {
      return Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: _displayAlert(consumer),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _displayAlert(MainAppControllerProvider consumer) {
    if (consumer.getScan == true) {
      if (consumer.getMessageCard == 202) {
        return AlertDialog(
          title: const Text('Félicitation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Le payment à réussis'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                consumer.setScan(false);
              },
            ),
          ],
        );
      } else {
        return AlertDialog(
          title: const Text('Erreur de paiement'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Le payment à échoué'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Reesayer'),
              onPressed: () {
                consumer.setScan(false);
              },
            ),
          ],
        );
      }
    } else {
      print("FALSE FALSE FALSE");

      return ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => QRViewExample(
              consumer: consumer,
            ),
          ));
        },
        child: const Text('Paid with Qr code'),
      );
    }
  }
}

class QRViewExample extends StatefulWidget {
  final MainAppControllerProvider consumer;

  QRViewExample({
    @required this.consumer,
  });
  @override
  State<StatefulWidget> createState() =>
      _QRViewExampleState(consumer: consumer);
}

class _QRViewExampleState extends State<QRViewExample> {
  final MainAppControllerProvider consumer;
  String token;
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  _QRViewExampleState({
    @required this.consumer,
  });

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void initState() {
    super.initState();

    init();
  }

  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(' Card: ${result.code}')
                  else
                    const Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () {
                            if (result != null) {
                              _sendData(result, widget.consumer);
                            }
                          },
                          child: const Text('Send'),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data)}');
                                } else {
                                  return const Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Future init() async {
    final tokenStore = await UserSecureStorage.getToken() ?? '';
    setState(() {
      this.token = tokenStore;
    });
  }

  _sendData(Barcode result, final MainAppControllerProvider consumer) async {
    print(result.code);
    try {
      await http
          .post(Uri.http('138.68.112.53', '/market/api/cart/payment'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer ${this.token}',
              },
              body: json.encode({
                "card_uid": result.code,
              }))
          .then((http.Response res) {
        consumer.setScan(true);
        consumer.setMessageCard(res.statusCode);
        Navigator.pop(context);
      });
    } catch (e) {
      // _loadingSignUp = false;
      // notifyListeners();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
