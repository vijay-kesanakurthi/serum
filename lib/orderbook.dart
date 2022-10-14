// ignore_for_file: avoid_print, prefer_is_empty

import 'package:alert/alert.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

Future fetchData(String typ, String address) async {
  try {
    final response = await http.get(Uri.parse(
        "https://saikishore222.pythonanywhere.com/order?add=$address&type=$typ&limit=25"));

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load album');
    }
  } catch (e) {
    print(e);
  }
}

class Orderbook extends StatefulWidget {
  const Orderbook({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrderbookState createState() => _OrderbookState();
}

class _OrderbookState extends State<Orderbook> {
  String dropdownvalue = 'ALL';
  String dropdownvalue2 = "SOl - USDC";
  String dropAddress = "9wFFyRfZBsuAha4YcuxcXLKwMxJR43S7fPfQLusDBzvT";
  var items = ['ALL', 'ASKS', 'BIDS'];
  var items2 = ["SOl - USDC", "BTC - USDC", "SRM - USDC"];

  var address = {
    "SOl - USDC": "9wFFyRfZBsuAha4YcuxcXLKwMxJR43S7fPfQLusDBzvT",
    "BTC - USDC": "A8YFbxQYFVqKZaoYJLLUVcQiWP7G2MeEgW5wsAQgMvFw",
    "SRM - USDC": "ByRys5tuUWDgL73G8JBAEfkdFf8JWBzPBDHsBVQ5vbQA"
  };

  // ignore: prefer_final_fields
  List<dynamic> asks = [];
  List<dynamic> bids = [];
  void fetch() {
    fetchData('ask', dropAddress)
        .then((value) => setState(
              () {
                asks = value;
              },
            ))
        .catchError((e) => {Alert(message: e)});
    fetchData('bid', dropAddress)
        .then((value) => setState(
              () {
                bids = value;
              },
            ))
        .catchError((e) => {Alert(message: e)});
  }

  @override
  void initState() {
    super.initState();
    fetch();
    // Timer.periodic(const Duration(seconds: 20), (timer) {
    //   fetch();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Color.fromARGB(255, 46, 34, 46),
            Color.fromARGB(255, 39, 35, 43),
            Color.fromARGB(255, 36, 35, 42),
            Color.fromARGB(255, 34, 36, 41),
          ]),
        ),
        child: ListView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Orderbook",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DropdownButton(
                        value: dropdownvalue2,
                        dropdownColor: const Color.fromARGB(255, 33, 36, 41),
                        borderRadius: BorderRadius.circular(10),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: items2.map((String item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                item,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue2) {
                          setState(() {
                            dropdownvalue2 = newValue2!;
                            dropAddress = address[dropdownvalue2]!;
                            fetch();
                          });
                        },
                      ),
                      DropdownButton(
                        value: dropdownvalue,
                        dropdownColor: const Color.fromARGB(255, 33, 36, 41),
                        borderRadius: BorderRadius.circular(10),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                items,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                            fetch();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            asks.length == 0 || bids.length == 0
                ? SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      child: LoadingAnimationWidget.hexagonDots(
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  )
                : dropdownvalue == "ALL"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _createDataTable("ASKS", "Small"),
                          _createDataTable("BIDS", "Small"),
                        ],
                      )
                    : Center(child: _createDataTable(dropdownvalue, "Large"))
          ],
        ),
      ),
    );
  }

  Container _createDataTable(String typ, String size) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 25, 27, 31),
        borderRadius: BorderRadius.circular(15.0),
      ),
      height: size == "Small"
          ? (MediaQuery.of(context).size.height - 200) / 2
          : MediaQuery.of(context).size.height - 200,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0),
      child: DataTable2(
        columns: _createColumns(),
        rows: _createRows(typ),
      ),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn2(
        label: Text(
          'Price',
          style: TextStyle(
              color: Colors.grey[300],
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        // size: ColumnSize.L,
      ),
      DataColumn2(
        // fixedWidth: 120,
        label: Text(
          'Size',
          style: TextStyle(
              color: Colors.grey[300],
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        size: ColumnSize.L,
      ),
      DataColumn2(
        // fixedWidth: 120,
        label: Text(
          'Total',
          style: TextStyle(
              color: Colors.grey[300],
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        // size: ColumnSize.L,
      )
    ];
  }

  List<DataRow> _createRows(String typ) {
    if (typ == 'BIDS') {
      return bids
          .map((book) => DataRow(
                cells: [
                  DataCell(
                    Text(
                      book['price'].toStringAsFixed(3),
                      style: const TextStyle(
                        color: Colors.green,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      book['size'].toStringAsFixed(3),
                      style: const TextStyle(
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      (book['price'] * book['size']).toStringAsFixed(3),
                      style: const TextStyle(
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ))
          .toList();
    }
    return asks
        .map((book) => DataRow(
              cells: [
                DataCell(Text(
                  book['price'].toStringAsFixed(3),
                  style: const TextStyle(
                    color: Colors.red,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
                DataCell(Text(
                  book['size'].toStringAsFixed(3),
                  style: const TextStyle(
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
                DataCell(Text(
                  (book['price'] * book['size']).toStringAsFixed(3),
                  style: const TextStyle(
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
              ],
            ))
        .toList();
  }
}
