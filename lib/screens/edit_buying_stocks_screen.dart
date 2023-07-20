import 'package:flutter/material.dart';
import 'package:mystocks/core/purchased_securities_collection.dart';

class EditBuyingStockScreen extends StatelessWidget {
  final PurchasedSecurityItem _editItem;

  const EditBuyingStockScreen(this._editItem, {super.key});

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

  Widget _makeWidget(){
    return Column(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: _makeWidget()
    );
  }
}
