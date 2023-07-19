import 'package:flutter/material.dart';
import 'package:mystocks/core/services.dart';
import 'package:mystocks/data/securities_price_info.dart';
import 'package:mystocks/screens/stock_count_edit_screen.dart';

class StockInfoScreen extends StatelessWidget {
  final SecuritiesPriceInfo _secPrice;

  final Services _services;

  const StockInfoScreen(this._services , this._secPrice, {super.key});

  Widget _buildStockItem(int index) {
    return const SizedBox(
      height: 50,
      child: Row(
        children: [
          SizedBox(width: 10),
          CircleAvatar(child: Text('Text')),
          SizedBox(width: 10),
          SizedBox(
            width: 120,
            height: 30,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Колличество',
              ),
            ),
          ),
          SizedBox(width: 10),
          SizedBox(
            width: 120,
            height: 30,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Цена',
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Stock"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => StockCountEditScreen(_services , _secPrice),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: 200,
        itemBuilder: (context, index) {
          return _buildStockItem(index);
        },
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(height: 4),
      ),
    );
  }
}
