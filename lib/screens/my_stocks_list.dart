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
    const oneSec = Duration(seconds: 3);
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
    String timeUpdate = "";

    var secPrice = _securitiesDataUpdater.getPrice(index);
    if(secPrice != null){
      secName = secPrice.tickerSymbol!;
      timeUpdate = secPrice.time!;
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
          const SizedBox(width: 10),
          const CircleAvatar(child: Text('Text')),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(secName),
              Text(price)
            ],
          ),
          const Spacer(),
          Text(timeUpdate),
          const SizedBox(width: 10),
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
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: _securitiesDataUpdater.countSecurities(),
        itemBuilder: (context, index) {
          return _buildListItem(index);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(height: 4),
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