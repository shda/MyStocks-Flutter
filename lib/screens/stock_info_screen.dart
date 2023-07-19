import 'package:flutter/material.dart';
import 'package:mystocks/core/purchased_securities_collection.dart';
import 'package:mystocks/core/services.dart';
import 'package:mystocks/data/securities_price_info.dart';
import 'package:mystocks/screens/stock_count_edit_screen.dart';

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
  // final SecuritiesPriceInfo _secPrice;
  //final Services _services;

  // const StockInfoScreen(this._services, this._secPrice, {super.key});

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
          return StockCountEditScreen(widget.services, widget.secPrice, item!);
        },
      ),
    ).then((value) => {setState(() {})});
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
            //items.removeAt(index);
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
                Text(item.countStock.toString()),
                const SizedBox(width: 10),
                Text(item.buyPriceByOne.toString()),
                const SizedBox(width: 10),
                Text(item.sum.toString()),
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
