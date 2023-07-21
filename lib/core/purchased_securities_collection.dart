import 'dart:convert';

import 'package:mystocks/core/interfaces/interface_purchased.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PurchasedSecuritiesCollection extends IPurchasedSecuritiesCollection {
  Map<String, PurchasedSecuritiesList> mapItems = {};

  void addItem(PurchasedSecuritiesList data) {
    mapItems.remove(data.tickerSymbol);
    mapItems[data.tickerSymbol] = data;
  }

  PurchasedSecuritiesCollection();

  void removeItem(int id) {
    mapItems.remove(id);
  }

  PurchasedSecuritiesCollection.fromJson(Map<String, dynamic> json)
      : mapItems = json['mapItems'];

  Map<String, dynamic> toJson() => {'mapItems': mapItems};

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  @override
  Future load() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final json = jsonDecode(contents);

      Map<String, dynamic> map = json['mapItems'];
      map.forEach((key, value) {
        var items = value['listByItems'] as List;
        for (var element in items) {
          var el = PurchasedSecurityItem.fromJson(element);
          var listSec = getListSecurities(el.tickerSymbol);
          var list = listSec.getList();
          list.add(el);
        }
      });
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  @override
  Future save() async {
    final file = await _localFile;
    final json = jsonEncode(toJson());
    file.writeAsString(json);
  }

  @override
  PurchasedSecuritiesList getListSecurities(String? tickerSymbol) {
    PurchasedSecuritiesList? list;

    if (tickerSymbol != null) {
      list = mapItems[tickerSymbol];

      if (list == null) {
        list = PurchasedSecuritiesList(tickerSymbol);
        mapItems[list.tickerSymbol] = list;
      }
    }

    return list!;
  }

  double getAllPurchasedSecuritiesPrice(){
    double allPrice = 0;
    for (var element in mapItems.values) {
      allPrice += element.getAllPrice();
    }

    return allPrice;
  }

  @override
  Iterable<PurchasedSecuritiesList> getAllSecurities() {
    return mapItems.values;
  }
}

class PurchasedSecuritiesList {
  final String tickerSymbol;
  late List<PurchasedSecurityItem> _listByItems;

  int getCountAllSecurities(){

    int count = 0;

    for (var element in _listByItems) {
      count += element.countStock;
    }

    return count;
  }

  double getAllPrice(){
    double count = 0;

    for (var element in _listByItems) {
      count += element.countStock * element.buyPriceByOne;
    }

    return count;
  }

  PurchasedSecurityItem createItem() {
    var item = PurchasedSecurityItem(tickerSymbol);
    _listByItems.add(item);
    return item;
  }

  List<PurchasedSecurityItem> getList() => _listByItems;

  PurchasedSecuritiesList(this.tickerSymbol) {
    _listByItems = [];
  }

  PurchasedSecuritiesList.fromJson(Map<String, dynamic> json)
      : tickerSymbol = json['tickerSymbol'],
        _listByItems = json['listByItems'];

  Map<String, dynamic> toJson() => {
        'tickerSymbol': tickerSymbol,
        'listByItems': _listByItems,
      };
}

class PurchasedSecurityItem {
  final String tickerSymbol;
  late int countStock = 0;
  late double buyPriceByOne = 0;

  double get sum => buyPriceByOne * countStock;

  PurchasedSecurityItem(this.tickerSymbol);

  PurchasedSecurityItem.fromJson(Map<String, dynamic> json)
      : tickerSymbol = json['tickerSymbol'],
        countStock = json['countStock'],
        buyPriceByOne = json['buyPriceByOne'];

  Map<String, dynamic> toJson() => {
        'tickerSymbol': tickerSymbol,
        'countStock': countStock,
        'buyPriceByOne': buyPriceByOne
      };
}
