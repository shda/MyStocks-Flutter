import 'package:mystocks/core/interfaces/interface_purchased.dart';
import 'package:mystocks/data/interface_intermediary.dart';
import 'interfaces/interface_user_securities.dart';

class Services {
  final IPurchasedSecuritiesCollection purchasedSecuritiesCollection;
  final IIntermediary intermediary;
  final IUserSecurities userSecurities;

  Services(
      {required this.purchasedSecuritiesCollection,
      required this.intermediary,
      required this.userSecurities});
}
