import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mystocks/core/securities_data_updater.dart';
import 'package:mystocks/core/services.dart';
import 'package:mystocks/data/securities_price_info.dart';
import 'package:mystocks/screens/stock_info_screen.dart';

class StocksListScreen extends State<MyStocksListPage>
    implements ISecuritiesUpdate {
  late Timer _timer;
  late SecuritiesDataUpdater _securitiesDataUpdater;
  final Services _services;

  StocksListScreen(this._services) {
    _securitiesDataUpdater = SecuritiesDataUpdater();
    _securitiesDataUpdater.setPriceListener(this);
    _securitiesDataUpdater.setSecuritiesNames({"AFLT", "SBER"});
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 3);
    _timer = Timer.periodic(oneSec, (timer) {
      _securitiesDataUpdater.requestSecurities();
    });
  }

  void stopTimer() {
    _timer.cancel();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  @override
  void onUpdateSecuritiesPrice() {
    setState(
      () {},
    );
  }

  void _onTapItem(int index, SecuritiesPriceInfo secPrice) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StockInfoScreen(_services , secPrice),
      ),
    );
  }

  Widget _buildListItem(int index) {
    String secName = "Null";
    String price = "";
    String timeUpdate = "";

    var secPrice = _securitiesDataUpdater.getPrice(index);
    if (secPrice != null) {
      secName = secPrice.tickerSymbol!;
      timeUpdate = secPrice.time!;
      if (secPrice.currentPrice != null) {
        var val = secPrice.currentPrice;
        price = "$val";
      }
    }

    return GestureDetector(
        onTap: () => {
          if(secPrice != null){
            _onTapItem(index, secPrice),
          }
        },
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              const SizedBox(width: 10),
              const CircleAvatar(child: Text('Text')),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(secName), Text(price)],
              ),
              const Spacer(),
              Text(timeUpdate),
              const SizedBox(width: 10),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: _securitiesDataUpdater.countSecurities(),
        itemBuilder: (context, index) {
          return _buildListItem(index);
        },
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(height: 4),
      ),
    );
  }
}

class MyStocksListPage extends StatefulWidget {
  final Services services;
  const MyStocksListPage({super.key, required this.title , required this.services});

  final String title;

  @override
  State<MyStocksListPage> createState() => StocksListScreen(services);
}
