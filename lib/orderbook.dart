import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future fetchData(String typ, String address) async {
  final response = await http.get(Uri.parse(
      "https://saikishore222.pythonanywhere.com/order?add=$address&type=$typ&limit=10"));

  if (response.statusCode == 200) {
    return json.decode(response.body) as List<dynamic>;
  } else {
    throw Exception('Failed to load album');
  }
}

class Orderbook extends StatefulWidget {
  @override
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
    Timer mytimer = Timer.periodic(Duration(seconds: 50), (timer) {
      fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Orderbook",
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton(
                      value: dropdownvalue2,
                      dropdownColor: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: items2.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              item,
                              style: TextStyle(color: Colors.white),
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
                      dropdownColor: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              items,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Center(child: _createDataTable(dropdownvalue))
        ],
      ),
    );
  }

  DataTable _createDataTable(String typ) {
    return DataTable(
        columns: _createColumns(),
        rows: typ == "ALL"
            ? _createRows('ASKS') + _createRows('BIDS')
            : _createRows(typ));
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(
          label: Text(
        'Price',
        style: TextStyle(
            color: Colors.grey[300],
            fontSize: 18.0,
            fontWeight: FontWeight.bold),
      )),
      DataColumn(
          label: Text(
        'Size',
        style: TextStyle(
            color: Colors.grey[300],
            fontSize: 18.0,
            fontWeight: FontWeight.bold),
      )),
      DataColumn(
          label: Text(
        'Total',
        style: TextStyle(
            color: Colors.grey[300],
            fontSize: 18.0,
            fontWeight: FontWeight.bold),
      ))
    ];
  }

  List<DataRow> _createRows(String typ) {
    if (typ == 'BIDS') {
      return bids
          .map((book) => DataRow(
                cells: [
                  DataCell(Text(
                    book['price'].toStringAsFixed(4),
                    style: TextStyle(color: Colors.green),
                  )),
                  DataCell(Text(
                    book['size'].toStringAsFixed(4),
                    style: TextStyle(color: Colors.white),
                  )),
                  DataCell(Text(
                    (book['price'] * book['size']).toStringAsFixed(4),
                    style: TextStyle(color: Colors.white),
                  ))
                ],
              ))
          .toList();
    }
    return asks
        .map((book) => DataRow(
              cells: [
                DataCell(Text(
                  book['price'].toStringAsFixed(4),
                  style: TextStyle(color: Colors.red),
                )),
                DataCell(Text(
                  book['size'].toStringAsFixed(4),
                  style: TextStyle(color: Colors.white),
                )),
                DataCell(Text(
                  (book['price'] * book['size']).toStringAsFixed(4),
                  style: TextStyle(color: Colors.white),
                ))
              ],
            ))
        .toList();
  }
}
