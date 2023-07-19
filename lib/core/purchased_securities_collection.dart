import 'package:mystocks/core/interface_purchased.dart';

class PurchasedSecuritiesCollection extends IPurchasedSecuritiesCollection {
  Map<String, PurchasedSecuritiesList> mapItems = {};

  void addItem(PurchasedSecuritiesList data) {
    mapItems.remove(data.tickerSymbol);
    mapItems[data.tickerSymbol] = data;
  }

  void removeItem(int id) {
    mapItems.remove(id);
  }

  PurchasedSecuritiesCollection();

  void load() async {}

  void save() async {}
}

class PurchasedSecurityItem {
  final String tickerSymbol;
  final int id;
  final int countStock;
  final double buyPriceByOne;

  double get sum => buyPriceByOne * countStock;

  PurchasedSecurityItem(
      this.id, this.countStock, this.buyPriceByOne, this.tickerSymbol);
}

class PurchasedSecuritiesList {
  final String tickerSymbol;
  late List<PurchasedSecurityItem> _listByItems;

  List<PurchasedSecurityItem> getList() => _listByItems;

  PurchasedSecuritiesList(this.tickerSymbol) {
    _listByItems = List<PurchasedSecurityItem>.empty();
  }
}
