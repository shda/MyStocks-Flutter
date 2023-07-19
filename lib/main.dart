import 'package:flutter/material.dart';
import 'core/purchased_securities_collection.dart';
import 'core/services.dart';
import 'screens/my_stocks_list_screen.dart';

void main() {

  var services = Services(
      PurchasedSecuritiesCollection());

  runApp(MyApp(services));
}

class MyApp extends StatelessWidget {
  final Services _services;
  const MyApp(this._services, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test',
      darkTheme: ThemeData.dark(),
      home: MyStocksListPage(title: 'My Stocks' , services: _services),
    );
  }
}