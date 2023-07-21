import 'package:mystocks/data/securities_info.dart';

import 'securities_price_info.dart';

abstract class IIntermediary {
   Future<Map<String, SecuritiesPriceInfo>> requestLastPrice(Iterable<String> tickerSymbols) ;
   Future<Map<String, SecuritiesInfo>> requestAllSecuritiesInfo();
}