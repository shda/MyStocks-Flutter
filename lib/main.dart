import 'package:flutter/material.dart';
import 'package:mystocks/debug/debug_dummy_intermediary.dart';
import 'package:mystocks/moex/moex_intermediary_impl.dart';
import 'core/purchased_securities_collection.dart';
import 'core/services.dart';
import 'core/user_securities.dart';
import 'data/interface_intermediary.dart';
import 'screens/my_stocks_list_screen.dart';

void main() async{
  runApp(MyApp(await _createServices()));
}

Future<Services>  _createServices() async{
  var purchasedSecuritiesCollection = PurchasedSecuritiesCollection();
  await purchasedSecuritiesCollection.load();

  var userSecurities = UserSecurities();
  await userSecurities.load();

  var services = Services(
    intermediary: _createIntermediary(),
    userSecurities: userSecurities,
    purchasedSecuritiesCollection: purchasedSecuritiesCollection,
  );

  return services;
}

IIntermediary _createIntermediary(){
  return MoexIntermediaryImpl();
  //return DummyIntermediary();
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