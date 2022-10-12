import 'package:alert/alert.dart';
import 'package:flutter/material.dart';

import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:phantom_connect/phantom_connect.dart';
import 'package:serumswap/coin_market.dart';
import 'package:serumswap/phantom.dart';

class Home extends StatefulWidget {
  final Phantom phantom;
  const Home({super.key, required this.phantom});

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
      "label": "GDoge",
      "value": "GDoge",
      "address": "6SKogZxCWY9jKsKPMT3ChJUhQxAEeB6NjVidXQK6TEdW",
      "symbol": "GDoge",
      "tokenSymbol": "GDOGE",
      "name": "Golden Doge Solana",
      "decimals": 1,
      "icon": SizedBox(
        key: UniqueKey(),
        width: 20,
        height: 20,
        child: Image.network(
            "https://raw.githubusercontent.com/solana-labs/token-list/main/assets/mainnet/6SKogZxCWY9jKsKPMT3ChJUhQxAEeB6NjVidXQK6TEdW/Logo.png"),
      )
    },
    {
      "label": "SRM",
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
  late Map<String, dynamic> price;

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
  }

  @override
  void dispose() {
    super.dispose();
    _firsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 25, 27, 31),
            borderRadius: BorderRadius.circular(15.0)),
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Swap",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            Container(
              height: 20,
            ),
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 33, 36, 41),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  // border: Border.all(width: 2),
                                  color: Color.fromARGB(255, 33, 36, 41),
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
                                    _firsController.text =
                                        "${input * data[first][second]}";
                                  });
                                },
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    hintText: "0.0",
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 178, 185, 210),
                                        fontSize: 22),
                                    border: InputBorder.none,
                                    focusColor: Colors.white),
                              ),
                            ),
                            CoolDropdown(
                              resultBD: BoxDecoration(
                                  color: Color.fromARGB(255, 64, 68, 79),
                                  borderRadius: BorderRadius.circular(20.0)),
                              resultTS: TextStyle(
                                color: Colors.white,
                              ),
                              dropdownBD: BoxDecoration(
                                color: Color.fromARGB(255, 64, 68, 79),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              selectedItemBD: BoxDecoration(
                                color: Color.fromARGB(255, 44, 47, 54),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              selectedItemTS: TextStyle(
                                color: Color.fromARGB(255, 228, 228, 228),
                              ),
                              unselectedItemTS: TextStyle(
                                color: Color.fromARGB(255, 228, 228, 228),
                              ),
                              dropdownList: itemList,
                              onChange: (selected) async {
                                setState(() {
                                  first = selected['tokenSymbol'];
                                });
                                data = await coinMarket.toUSDC(first, second);
                                setState(() {
                                  data = data;
                                });
                                _firsController.text =
                                    "${input * data[first][second]}";
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
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 33, 36, 41),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                  // border: Border.all(width: 2),
                                  color: Color.fromARGB(255, 33, 36, 41),
                                  borderRadius: BorderRadius.circular(10)),
                              width: 150,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: _firsController,
                                enabled: false,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                                decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    hintText: "0.0",
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 178, 185, 210),
                                        fontSize: 22),
                                    border: InputBorder.none,
                                    focusColor: Colors.white),
                              ),
                            ),
                            CoolDropdown(
                              dropdownList: itemList,
                              resultBD: BoxDecoration(
                                  color: Color.fromARGB(255, 64, 68, 79),
                                  borderRadius: BorderRadius.circular(20.0)),
                              resultTS: TextStyle(
                                color: Colors.white,
                              ),
                              dropdownBD: BoxDecoration(
                                color: Color.fromARGB(255, 64, 68, 79),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              selectedItemBD: BoxDecoration(
                                color: Color.fromARGB(255, 44, 47, 54),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              selectedItemTS: TextStyle(
                                color: Color.fromARGB(255, 228, 228, 228),
                              ),
                              unselectedItemTS: TextStyle(
                                color: Color.fromARGB(255, 228, 228, 228),
                              ),
                              onChange: (selected) async {
                                setState(() {
                                  second = selected['tokenSymbol'];
                                });
                                data = await coinMarket.toUSDC(first, second);
                                setState(() {
                                  data = data;
                                });
                                _firsController.text =
                                    "${input * data[first][second]}";
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
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 75,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 33, 36, 41),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 25, 27, 31),
                                spreadRadius: 5,
                              )
                            ]),
                        child: Icon(
                          Icons.arrow_downward_sharp,
                          size: 25,
                          color: Color.fromARGB(255, 207, 198, 198),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // data.isEmpty
            //     ? Text("")
            //     : Container(
            //         padding: EdgeInsets.only(right: 40, top: 10),
            //         alignment: Alignment.topRight,
            //         child: Text("1 $first = ${data[first]?["USD"]} USD",
            //             style: TextStyle(color: Colors.red)),
            //       ),

            // data.isEmpty
            //     ? Text("")
            //     : Container(
            //         padding: EdgeInsets.only(right: 30, top: 10),
            //         alignment: Alignment.topRight,
            //         child: Text("1 $second = ${data[second]?["USD"]} USD",
            //             style: TextStyle(color: Colors.red)),
            //       ),
            // Container(margin: const EdgeInsets.all(20)),
            SizedBox(
              height: 30,
            ),
            data[first] == null
                ? Text("")
                : Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "1 $first = ${data[first][second]} $second",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
            Container(margin: const EdgeInsets.all(10)),
            widget.phantom.connected
                ? TextButton(
                    onPressed: () {
                      print(widget.phantom.connected);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 23, 42, 66),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Swap",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: () async {
                      if (!widget.phantom.connected) {
                        print(widget.phantom.connected);
                        setState(() {
                          widget.phantom.connect();
                          print("Done");
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 23, 42, 66),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Connect Wallet",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 76, 137, 224),
                                fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
