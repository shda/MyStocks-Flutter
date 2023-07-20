import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mystocks/core/securities_data_updater.dart';
import 'package:mystocks/core/services.dart';
import 'package:mystocks/data/securities_price_info.dart';
import 'package:mystocks/screens/stock_info_screen.dart';
import 'package:sprintf/sprintf.dart';

class StocksListScreen extends State<MyStocksListPage>
    implements ISecuritiesUpdate {
  late Timer _timer;
  late SecuritiesDataUpdater _securitiesDataUpdater;

  @override
  void initState() {
    super.initState();

    _securitiesDataUpdater =
        SecuritiesDataUpdater(widget.services.intermediary);
    _securitiesDataUpdater.setPriceListener(this);
    _securitiesDataUpdater.setSecuritiesNames({"AFLT", "SBER"});
    startTimer();
  }

  void startTimer() {
    _securitiesDataUpdater.requestSecurities();
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
        builder: (context) => StockInfoScreen(
            secPrice: secPrice, title: "Hello", services: widget.services),
      ),
    );
  }

  Widget _buildListItem(int index) {
    String secName = "None";
    String price = "---";
    String timeUpdate = "---";

    String currentPriceMy = "---";
    String priceIfBy = "---";

    String priceDifferenceString = "---";
    String percentDifferenceString = "---";

    bool isGrowthUp = false;

    var secPrice = _securitiesDataUpdater.getPrice(index);
    if (secPrice != null) {
      double currentPriceSec = secPrice.currentPrice!;
      int countAllBuyingSec = 0;
      double myAllPriceSec = 0;
      double canAllPriceSec = 0;

      double priceDifference = 0;
      double percentDifference = 0;

      var listCollection = widget.services.purchasedSecuritiesCollection;
      var listSec = listCollection.getListSecurities(secPrice.tickerSymbol);

      if (listSec != null) {
        countAllBuyingSec = listSec.getCountAllSecurities();
        myAllPriceSec = listSec.getAllPrice();
        canAllPriceSec = secPrice.currentPrice! * countAllBuyingSec;

        priceDifference = canAllPriceSec - myAllPriceSec;
        percentDifference = (priceDifference / canAllPriceSec) * 100;

        isGrowthUp = percentDifference >= 0;
      }

      secName = secPrice.tickerSymbol!;
      timeUpdate = secPrice.time!;

      price = sprintf('%.1f р', [currentPriceSec]);
      currentPriceMy = sprintf('%.1f р', [myAllPriceSec]);
      priceIfBy = sprintf('%.1f р', [canAllPriceSec]);

      priceDifferenceString = sprintf('%.1f р', [priceDifference]);
      percentDifferenceString = sprintf('%.1f %', [percentDifference]);
    }

    var color = isGrowthUp ? Colors.green: Colors.deepOrange ;

    return GestureDetector(
        onTap: () => {
              if (secPrice != null)
                {
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
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text(currentPriceMy), Text(priceIfBy)],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    priceDifferenceString,
                    style: TextStyle(color: color),
                  ),
                  Text(
                    percentDifferenceString,
                    style: TextStyle(color: color),
                  )
                ],
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

  const MyStocksListPage(
      {super.key, required this.title, required this.services});

  final String title;

  @override
  State<MyStocksListPage> createState() => StocksListScreen();
}
