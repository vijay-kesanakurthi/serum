import 'dart:async';

import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:phantom_connect/phantom_connect.dart';
import 'package:serumswap/acount.dart';
import 'package:serumswap/home.dart';
import 'package:serumswap/orderbook.dart';
import 'package:serumswap/phantom.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(),
    home: const MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription sub;

  final Phantom phantom = Phantom();
  late PhantomConnect phantomConnect = phantom.phantomConnect();

  int selected = 0;

  dynamic screens;
  @override
  void initState() {
    phantomConnect = phantom.phantomConnect();

    screens = [
      Home(
        phantomConnect: phantomConnect,
        phantom: phantom,
      ),
      Orderbook()
    ];
    super.initState();
    handleIncomingLinks(context);
  }

  void handleIncomingLinks(context) async {
    sub = uriLinkStream.listen((Uri? link) async {
      Map<String, String> params = link?.queryParameters ?? {};
      if (params.containsKey("errorCode")) {
        Alert(message: params["errorMessage"].toString());
      } else {
        switch (link?.path) {
          case '/connect':
            if (phantomConnect.createSession(params)) {
              // connected = true;
              setState(() {
                phantom.setConnected(true);
              });
            } else {}
            break;
          case '/disconnect':
            setState(() {
              phantom.setConnected(false);
            });
            break;
          case '/signAndSendTransaction':
            var data = phantomConnect.decryptPayload(
                data: params["data"]!, nonce: params["nonce"]!);
            await launchUrl(
              Uri.parse(
                  "https://explorer.solana.com/tx/${data['signature']}?cluster=devnet"),
              mode: LaunchMode.inAppWebView,
            );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(backgroundColor: Color.fromARGB(149, 10, 8, 8), actions: [
      //   phantom.connected
      //       ? TextButton(
      //           onPressed: () {
      //             Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) => Account(
      //                           phantomConnect: phantomConnect,
      //                           phantom: phantom,
      //                         )));
      //           },
      //           child: Container(
      //             padding: EdgeInsets.only(right: 20),
      //             child: Column(
      //               children: [
      //                 Icon(Icons.account_circle_outlined, size: 30),
      //               ],
      //             ),
      //           ),
      //         )
      //       : TextButton(
      //           onPressed: () {
      //             phantom.connect(phantomConnect);
      //           },
      //           child: Container(
      //             padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      //             child: Row(
      //               children: const [
      //                 Text(
      //                   "Connect Phantom",
      //                   style: TextStyle(color: Colors.white, fontSize: 20),
      //                 ),
      //                 Icon(
      //                   Icons.account_balance_wallet,
      //                   size: 25,
      //                 ),
      //               ],
      //             ),
      //           ),
      //         )
      // ]),
      backgroundColor: Color.fromARGB(255, 42, 35, 44),
      body: selected == 2
          ? Account(phantomConnect: phantomConnect, phantom: phantom)
          : screens[selected],
      bottomNavigationBar: nav(),
    );
  }

  BottomNavigationBar nav() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 28,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_rounded),
          label: 'Business',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.settings),
        //   label: 'Settings',
        // ),
      ],
      currentIndex: selected,
      selectedItemColor: Color.fromARGB(255, 255, 255, 255),
      unselectedItemColor: Colors.blueGrey,
      onTap: (value) {
        setState(() {
          selected = value;
        });
      },
    );
  }
}
