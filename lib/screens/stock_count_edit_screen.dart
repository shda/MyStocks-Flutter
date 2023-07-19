import 'package:flutter/material.dart';
import 'package:mystocks/core/services.dart';
import 'package:mystocks/data/securities_price_info.dart';

class StockCountEditScreen extends StatelessWidget {
  final Services _services;
  final SecuritiesPriceInfo _secPrice;
  const StockCountEditScreen(this._services , this._secPrice, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Stock"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: const Icon(Icons.add),
      ),
      body: Text("Hello"),
    );
  }
}
