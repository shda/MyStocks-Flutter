import 'securities_price_info.dart';

abstract class IIntermediary
{
   Future<Map<String, SecuritiesPriceInfo>> requestLastPrice(Iterable<String> tickerSymbols) ;
}