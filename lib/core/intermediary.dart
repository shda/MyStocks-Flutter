import 'package:mystocks/data/interface_intermediary.dart';
import 'package:mystocks/data/securities_price_info.dart';

class Intermediary
{
  final IIntermediary intermediary;

  Future<Map<String, SecuritiesPriceInfo>> requestLastPrice(Iterable<String> tickerSymbols) =>
      intermediary.requestLastPrice(tickerSymbols);

  Intermediary(this.intermediary);
}