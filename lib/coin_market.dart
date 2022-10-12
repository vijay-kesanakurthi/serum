// import 'dart:io';

import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class CoinMarket {
  Future getPrice() async {
    var response = await http.get(Uri.parse(
        "https://api.coingecko.com/api/v3/simple/price?ids=usd-coin,solana&vs_currencies=usd"));

    return convert.jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future toUSDC(String first, String second) async {
    var response = await http.get(Uri.parse(
        "https://min-api.cryptocompare.com/data/pricemulti?fsyms=$first,$second&tsyms=USD,$second"));

    return convert.jsonDecode(response.body) as Map;
  }
}
