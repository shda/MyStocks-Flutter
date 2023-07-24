import 'package:mystocks/core/purchased_securities_collection.dart';
import '../services.dart';

abstract class IPurchasedSecuritiesCollection  extends IService{
  PurchasedSecuritiesList? getListSecurities(String? tickerSymbol);
  Iterable<PurchasedSecuritiesList> getAllSecurities();
  double getAllPurchasedSecuritiesPrice();
  Future load();
  Future save();
}
