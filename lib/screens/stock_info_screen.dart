import 'package:flutter/material.dart';
import 'package:mystocks/core/purchased_securities_collection.dart';
import 'package:mystocks/core/services.dart';
import 'package:mystocks/data/securities_price_info.dart';
import 'package:mystocks/screens/edit_buying_stocks_screen.dart';
import 'package:sprintf/sprintf.dart';

class StockInfoScreen extends StatefulWidget {
  final Services services;
  final SecuritiesPriceInfo secPrice;

  const StockInfoScreen(
      {super.key,
      required this.title,
      required this.services,
      required this.secPrice});

  final String title;

  @override
  State<StockInfoScreen> createState() => _StockInfoScreen();
}

class _StockInfoScreen extends State<StockInfoScreen> {
  Widget? _buildList(BuildContext context, PurchasedSecuritiesList? list) {
    if (list == null) {
      return null;
    }

    var listPrices = list.getList();

    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: listPrices.length,
      itemBuilder: (context, index) {
        return _buildStockItem(context, index, list);
      },
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(height: 4),
    );
  }

  void _onTapToItem(BuildContext context, PurchasedSecuritiesList list,
      [PurchasedSecurityItem? item]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          item ??= list.createItem();
          return EditBuyingStockScreen(item!);
        },
      ),
    ).then((value) {
      setState(() {

      });
      _savePurchasedSecuritiesCollection();
    },);
  }

  void _savePurchasedSecuritiesCollection(){
    widget.services.purchasedSecuritiesCollection.save();
  }

  Widget _buildStockItem(
      BuildContext context, int index, PurchasedSecuritiesList list) {
    var listPrices = list.getList();
    PurchasedSecurityItem item = listPrices[index];

    return Dismissible(
        key: ObjectKey(index),
        background: Container(
          color: Colors.green,
        ),
        onDismissed: (DismissDirection direction) {
          setState(() {
            listPrices.removeAt(index);
            _savePurchasedSecuritiesCollection();
          });
        },
        child: GestureDetector(
          onTap: () => {_onTapToItem(context, list, item)},
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                const SizedBox(width: 10),
                const CircleAvatar(child: Text('Text')),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${item.countStock} шт.'),
                    Text('${item.buyPriceByOne} р'),
                  ],
                ),
                const SizedBox(width: 30),
                Text(sprintf("%.2f р", [item.sum])),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var psCollection = widget.services.purchasedSecuritiesCollection;
    var list = psCollection.getListSecurities(widget.secPrice.tickerSymbol);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Stock"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (list == null) {
            return;
          }
          _onTapToItem(context, list);
        },
        child: const Icon(Icons.add),
      ),
      body: _buildList(context, list),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void activate() {
    super.activate();
  }
}
