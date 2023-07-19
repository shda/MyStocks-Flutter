import 'package:mystocks/core/purchased_securities_collection.dart';

abstract class IPurchasedSecuritiesCollection {
  PurchasedSecuritiesList? getListSecurities(String? tickerSymbol);
}
