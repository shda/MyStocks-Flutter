import 'package:flutter/material.dart';
import 'package:mystocks/core/purchased_securities_collection.dart';
import 'package:mystocks/core/services.dart';
import 'package:mystocks/data/securities_price_info.dart';

class StockCountEditScreen extends StatelessWidget {
  final Services _services;
  final SecuritiesPriceInfo _selectSecuritiesPrice;
  final PurchasedSecurityItem _editItem;

  const StockCountEditScreen(this._services, this._selectSecuritiesPrice,
      this._editItem,
      {super.key});

  void onChangeTextCount(String text){
    int? countStock =int.tryParse(text);
    if(countStock != null){
      _editItem.countStock = countStock;
    }
  }

  void onChangeTextPrice(String text){
    double? buyPriceByOne = double.tryParse(text);
    if(buyPriceByOne != null){
      _editItem.buyPriceByOne = buyPriceByOne;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editItem.tickerSymbol),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Количество акций',
              ),
              initialValue: _editItem.countStock.toString(),
              onChanged: onChangeTextCount,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Цена за акцию',
              ),
              initialValue: _editItem.buyPriceByOne.toString(),
              onChanged: onChangeTextPrice,
            ),
          ),
        ],
      ),
    );
  }
}
