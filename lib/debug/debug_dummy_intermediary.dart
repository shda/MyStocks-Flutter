import 'dart:math';

import 'package:mystocks/data/interface_intermediary.dart';
import 'package:mystocks/data/securities_info.dart';
import 'package:mystocks/data/securities_price_info.dart';

class DummyIntermediary extends IIntermediary {
  @override
  Future<Map<String, SecuritiesPriceInfo>> requestLastPrice(
      Iterable<String> tickerSymbols) async {

    Map<String, SecuritiesPriceInfo> map = {
      "SBER": SecuritiesPriceInfo(
          tickerSymbol: "SBER",
          currentPrice: Random().nextDouble() * 5 + 210,
          time: "17:00:00"),
    };

    return map;
  }

  @override
  Future<Map<String, SecuritiesInfo>> requestAllSecuritiesInfo() {
    // TODO: implement requestAllSecuritiesInfo
    throw UnimplementedError();
  }


}