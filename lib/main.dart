import 'dart:async';
import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serumswap/acount.dart';
import 'package:serumswap/home.dart';
import 'package:serumswap/orderbook.dart';
import 'package:serumswap/phantom.dart';
import 'package:serumswap/providers/wallet_state_provider.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => WalletStateProvider()),
        ],
        child: const MyApp(),
      )));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription sub;

  late Phantom phantom;

  int selected = 0;

  dynamic screens;
  @override
  void initState() {
    setState(() {
      phantom = Phantom();
      screens = [
        Home(
          phantom: phantom,
        ),
        Orderbook(),
        Account(
          phantom: phantom,
        )
      ];
    });

    super.initState();
    handleIncomingLinks(context);
  }

  void handleIncomingLinks(context) async {
    final provider = Provider.of<WalletStateProvider>(context, listen: false);
    sub = uriLinkStream.listen((Uri? link) async {
      Map<String, String> params = link?.queryParameters ?? {};

      if (params.containsKey("errorCode")) {
        Alert(message: params["errorMessage"].toString());
      } else {
        switch (link?.path) {
          case '/connect':
            if (phantom.phantomConnect.createSession(params)) {
              // connected = true;
              setState(() {
                provider.updateConnection(true);
              });
            } else {}
            break;
          case '/disconnect':
            setState(() {
              provider.updateConnection(false);
            });
            break;
          case '/signAndSendTransaction':
            var data = phantom.phantomConnect
                .decryptPayload(data: params["data"]!, nonce: params["nonce"]!);
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
      body: screens[selected],
      bottomNavigationBar: nav(),
    );
  }

  BottomNavigationBar nav() {
    return BottomNavigationBar(
      backgroundColor: Color.fromARGB(255, 8, 6, 6),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 28,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.swap_horiz, size: 32),
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
      selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
      unselectedItemColor: Colors.blueGrey,
      onTap: (value) {
        setState(() {
          selected = value;
        });
      },
    );
  }
}
