import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mystocks/debug/debug_dummy_intermediary.dart';
import 'package:mystocks/moex/moex_intermediary_impl.dart';
import 'core/purchased_securities_collection.dart';
import 'core/services.dart';
import 'core/user_securities.dart';
import 'data/interface_intermediary.dart';
import 'screens/my_stocks_list_screen.dart';
import 'package:window_size/window_size.dart';

void main() async{
  setupWindow();
  runApp(MyApp(await _createServices()));
}

const double windowWidth = 600;
const double windowHeight = 300;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('My Stocks');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    //setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

Future<IServicesCollection> _createServices() async{

  IServicesCollection sc = ServicesCollection();

  var psCollection = PurchasedSecuritiesCollection();
  await psCollection.load();
  sc.addService(psCollection);

  var userSecurities = UserSecurities();
  await userSecurities.load();
  sc.addService(userSecurities);

  sc.addService(_createIntermediary());

  return sc;
}

IIntermediary _createIntermediary(){
  return MoexIntermediaryImpl();
  //return DummyIntermediary();
}

class MyApp extends StatelessWidget {
  final IServicesCollection _services;
  const MyApp(this._services, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Stocks',
      theme: ThemeData.dark(),
      //darkTheme: ThemeData.dark(),
      home: MyStocksListPage(title: 'My Stocks' , services: _services),
    );
  }
}