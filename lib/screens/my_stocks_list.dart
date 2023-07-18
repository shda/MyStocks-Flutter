import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mystocks/core/securities_data_updater.dart';

class _MyStocksList extends State<MyStocksListPage> implements ISecuritiesUpdate {
  late Timer _timer;
  late SecuritiesDataUpdater _securitiesDataUpdater;

  _MyStocksList() {
    _securitiesDataUpdater = SecuritiesDataUpdater();
    _securitiesDataUpdater.setPriceListener(this);

    _securitiesDataUpdater.setSecuritiesNames({"AFLT","SBER"});

    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      _securitiesDataUpdater.requestSecurities();
    });
  }

  void stopTimer(){
    _timer.cancel();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  void onUpdateSecuritiesPrice() {
    setState(() {

    },);
  }

  Widget _buildListItem(int index)
  {
    String secName = "Null";
    String price = "";

    var secPrice = _securitiesDataUpdater.getPrice(index);
    if(secPrice != null){
      secName = secPrice.tickerSymbol!;
      if(secPrice.currentPrice != null){
        var val = secPrice.currentPrice;
        price = "$val";
      }

    }

    return Container(
      height: 50,
      color: Colors.amber[600],
      child: Row(
        children: [
          const Icon(Icons.co2),
          Column(
            children: [
              Text(secName),
              Text(price)
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _securitiesDataUpdater.countSecurities(),
        itemBuilder: (context, index) {
          return _buildListItem(index);
        },
      ),
    );
  }
}

class MyStocksListPage extends StatefulWidget {
  const MyStocksListPage({super.key, required this.title});

  final String title;

  @override
  State<MyStocksListPage> createState() => _MyStocksList();
}