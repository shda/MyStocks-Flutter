import 'package:mystocks/core/interface_purchased.dart';
import 'package:mystocks/data/interface_intermediary.dart';

class Services{
  final IPurchasedSecuritiesCollection purchasedSecuritiesCollection;
  final IIntermediary intermediary;

  Services(this.purchasedSecuritiesCollection, this.intermediary);
}