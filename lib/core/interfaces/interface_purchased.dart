import 'package:mystocks/core/purchased_securities_collection.dart';

abstract class IPurchasedSecuritiesCollection {
  PurchasedSecuritiesList? getListSecurities(String? tickerSymbol);
  Iterable<PurchasedSecuritiesList> getAllSecurities();
  double getAllPurchasedSecuritiesPrice();
  Future load();
  Future save();
}
