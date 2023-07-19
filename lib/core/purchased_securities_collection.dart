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

  @override
  PurchasedSecuritiesList? getListSecurities(String? tickerSymbol) {
    PurchasedSecuritiesList? list;

    if (tickerSymbol != null) {
      list = mapItems[tickerSymbol];

      if (list == null) {
        list = PurchasedSecuritiesList(tickerSymbol);
        mapItems[list.tickerSymbol] = list;
      }
    }

    return list;
  }
}

class PurchasedSecurityItem {
  final String tickerSymbol;
  late int countStock = 0;
  late double buyPriceByOne = 0;

  double get sum => buyPriceByOne * countStock;

  PurchasedSecurityItem(this.tickerSymbol);
}

class PurchasedSecuritiesList {
  final String tickerSymbol;
  late List<PurchasedSecurityItem> _listByItems;

  PurchasedSecurityItem createItem() {
    var item = PurchasedSecurityItem(tickerSymbol);
    _listByItems.add(item);
    return item;
  }

  List<PurchasedSecurityItem> getList() => _listByItems;

  PurchasedSecuritiesList(this.tickerSymbol) {
    _listByItems = [];
  }
}
