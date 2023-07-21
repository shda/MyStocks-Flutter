import 'package:mystocks/data/interface_intermediary.dart';
import 'package:mystocks/data/securities_price_info.dart';
import 'package:mystocks/moex/converter.dart';
import '../data/securities_info.dart';
import 'moex_parser.dart';
import 'dart:developer';

import 'package:http/http.dart' as http;

class MoexIntermediaryImpl extends IIntermediary {
  @override
  Future<Map<String, SecuritiesPriceInfo>> requestLastPrice(
      Iterable<String> tickerSymbols) async {

    try {
      String tickerSymbolsString = tickerSymbols.join(",");
      String request =
          "https://iss.moex.com/iss/engines/stock/markets/shares/boards/TQBR/securities.json?securities=$tickerSymbolsString&iss.only=marketdata&iss.meta=off";
      var responseBody = await requestGetByUrl(request);
      var dictMoexSec = MoexParser.parsingMarketDict(responseBody);
      return Converter.convert(dictMoexSec);
    } on Exception catch (e) {
      log(e.toString());
    }

    return Map<String, SecuritiesPriceInfo>.identity();
  }

  @override
  Future<Map<String, SecuritiesInfo>> requestAllSecuritiesInfo() async {
    try {
      String request = "https://iss.moex.com/iss/engines/stock/markets/shares/boards/TQBR/securities.json?iss.only=securities&iss.meta=off";
      var responseBody = await requestGetByUrl(request);
      var dictMoexSec = MoexParser.parsingAllSecuritiesDict(responseBody);
      return Converter.convertInfo(dictMoexSec);
    } on Exception catch (e) {
      log(e.toString());
    }
    return Map<String, SecuritiesInfo>.identity();
  }

  Future<String> requestGetByUrl(String urlRequest) async {
    var uri = Uri.parse(urlRequest);
    var get = await http.get(uri);
    return get.body;
  }
}
