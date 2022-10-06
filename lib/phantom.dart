import 'dart:async';

import 'package:phantom_connect/phantom_connect.dart';
import 'package:url_launcher/url_launcher.dart';

class Phantom {
  bool connected = false;

  PhantomConnect phantomConnect() {
    return PhantomConnect(
      appUrl: "https://solana.com",
      deepLink: "dapp://flutterbooksample.com",
    );
  }

  void setConnected(bool connect) {
    connected = connect;
  }

  void connect(phantomConnect) async {
    Uri connectUrl = phantomConnect.generateConnectUri(
        cluster: 'devnet', redirect: '/connect');
    try {
      await launchUrl(connectUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      print(e);
    }

    // Open the url using (url_launcher)[https://pub.dev/packages/url_launcher]]
  }
}
