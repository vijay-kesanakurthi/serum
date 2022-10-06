import 'dart:async';

import 'package:alert/alert.dart';
import 'package:flutter/material.dart';

import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:phantom_connect/phantom_connect.dart';
import 'package:serumswap/coin_market.dart';
import 'package:serumswap/phantom.dart';
import 'package:serumswap/phantom_connect_button.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List dropdownItemList = [
    {
      "label": "SOL",
      "value": "SOL",
      "tokenSymbol": "SOL",
      "mintAddress": "So11111111111111111111111111111111111111112",
      "tokenName": "Solana",
      "icon": SizedBox(
          key: UniqueKey(),
          width: 20,
          height: 20,
          child: Image.network(
            "https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/solana/info/logo.png",
          ))
    },
    {
      "label": "USDC",
      "value": "USDC",
      "tokenSymbol": "USDC",
      "mintAddress": "EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v",
      "tokenName": "USDC",
      "icon": SizedBox(
          key: UniqueKey(),
          width: 20,
          height: 20,
          child: Image.network(
              "https://raw.githubusercontent.com/trustwallet/assets/f3ffd0b9ae2165336279ce2f8db1981a55ce30f8/blockchains/ethereum/assets/0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48/logo.png"))
    },
    {
      "label": "soLink",
      "value": "soLINK",
      "tokenSymbol": "soLINK",
      "mintAddress": "CWE8jPTUYhdCTZYWPTe1o5DFqfdjzWKc9WKz6rSjQUdG",
      "tokenName": "Wrapped Chainlink (Sollet)",
      "icon": SizedBox(
        key: UniqueKey(),
        width: 20,
        height: 20,
        child: Image.network(
            "https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/ethereum/assets/0x514910771AF9Ca656af840dff83E8264EcF986CA/logo.png"),
      )
    },
    {
      "label": "Serum",
      "value": "Serum",
      "mintAddress": "SRMuApVNdxXokk5GT7XD5cUUgXMBCoAz2LHeuAoKWRt",
      "tokenName": "Serum",
      "tokenSymbol": "SRM",
      "icon": SizedBox(
          key: UniqueKey(),
          width: 20,
          height: 20,
          child: Image.network(
              "https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/ethereum/assets/0x476c5E26a75bd202a9683ffD34359C0CC15be0fF/logo.png"))
    }
  ];
  List itemList = [];
  late StreamSubscription sub;
  final Phantom phantom = Phantom();
  late Map<String, dynamic> price;

  late PhantomConnect phantomConnect;
  final CoinMarket coinMarket = CoinMarket();

  //fetching coin data
  String first = "SOL";
  String second = "SRM";
  Map data = {};
  double input = 0;

  final _firsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {
      phantomConnect = phantom.phantomConnect();

      for (int i = 0; i < dropdownItemList.length; i++) {
        itemList.add({
          'label': dropdownItemList[i]['label'],
          'value': dropdownItemList[i]['value'],
          'icon': dropdownItemList[i]['icon'],
          'tokenSymbol': dropdownItemList[i]['tokenSymbol']
        });
      }
    });

    coinMarket.toUSDC(first, second).then((value) => setState(() {
          data = value;
        }));
    _firsController.addListener(
      () {
        print(_firsController.text);
      },
    );

    handleIncomingLinks(context);
  }

  @override
  void dispose() {
    super.dispose();
    _firsController.dispose();
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
              print(phantom.connected);
            } else {}
            break;
          case '/disconnect':
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
      appBar: AppBar(backgroundColor: Color.fromARGB(149, 10, 8, 8), actions: [
        phantom.connected
            ? Container(
                padding: EdgeInsets.only(right: 20),
                child: Center(
                    child: Text(
                        " ${phantomConnect.userPublicKey.replaceRange(10, phantomConnect.userPublicKey.length, "...")}")),
              )
            : TextButton(
                onPressed: () {
                  phantom.connect(phantomConnect);
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: Row(
                    children: const [
                      Text(
                        "Connect Phantom",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Icon(
                        Icons.account_balance_wallet,
                        size: 25,
                      ),
                    ],
                  ),
                ),
              )
      ]),
      backgroundColor: Color.fromARGB(98, 0, 0, 0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    color: Color.fromARGB(255, 21, 16, 22),
                    borderRadius: BorderRadius.circular(10)),
                width: 150,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      if (value != "") {
                        input = double.parse(value);
                      } else {
                        input = 0;
                      }
                      _firsController.text = "${input * data[first][second]}";
                    });
                  },
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white, fontSize: 22),
                  decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 227, 225, 225),
                      hintText: "0",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 22),
                      border: InputBorder.none,
                      focusColor: Colors.white),
                ),
              ),
              CoolDropdown(
                dropdownList: itemList,
                onChange: (selected) async {
                  setState(() {
                    first = selected['tokenSymbol'];
                  });
                  data = await coinMarket.toUSDC(first, second);
                  setState(() {
                    data = data;
                  });
                  _firsController.text = "${input * data[first][second]}";
                },
                isAnimation: true,
                defaultValue: itemList[0],
                dropdownItemReverse: true,
                gap: 5,
                dropdownItemGap: 0,
                dropdownHeight: 220,
                dropdownItemMainAxis: MainAxisAlignment.start,
                resultMainAxis: MainAxisAlignment.start,
                resultWidth: 120,
              ),
            ],
          ),
          data.isEmpty
              ? Text("")
              : Text("1 $first = ${data[first]?["USD"]} USD",
                  style: TextStyle(color: Colors.red)),
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(20),
              height: 50,
              width: 60,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.circular(30)),
              child: Icon(
                Icons.swap_vert,
                size: 39,
                color: Color.fromARGB(255, 207, 198, 198),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    color: Color.fromARGB(255, 21, 16, 22),
                    borderRadius: BorderRadius.circular(10)),
                width: 150,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _firsController,
                  enabled: false,
                  style: TextStyle(color: Colors.white, fontSize: 22),
                  decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 227, 225, 225),
                      hintText: "0",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 22),
                      border: InputBorder.none,
                      focusColor: Colors.white),
                ),
              ),
              CoolDropdown(
                dropdownList: itemList,
                onChange: (selected) async {
                  setState(() {
                    second = selected['tokenSymbol'];
                  });
                  data = await coinMarket.toUSDC(first, second);
                  print(data);
                  setState(() {
                    data = data;
                  });
                  _firsController.text = "${input * data[first][second]}";
                },
                defaultValue: itemList[3],
                dropdownItemReverse: true,
                gap: 5,
                dropdownItemGap: 0,
                dropdownHeight: 220,
                dropdownItemMainAxis: MainAxisAlignment.start,
                resultMainAxis: MainAxisAlignment.start,
                resultWidth: 120,
              ),
            ],
          ),
          data.isEmpty
              ? Text("")
              : Text("1 $second = ${data[second]?["USD"]} USD",
                  style: TextStyle(color: Colors.red)),
          Container(margin: const EdgeInsets.all(20)),
          TextButton(
              onPressed: () async {
                Alert(message: "Connect to phantom wallet").show();
              },
              child: Container(
                  width: 100,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: const [
                      Icon(Icons.loop),
                      Text(
                        "Swap",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  )))
        ],
      ),
    );
  }
}
