import 'package:flutter/material.dart';
import 'package:mystocks/core/interfaces/interface_purchased.dart';
import 'package:mystocks/core/interfaces/interface_user_securities.dart';
import 'dart:async';
import 'package:mystocks/core/securities_data_updater.dart';
import 'package:mystocks/core/services.dart';
import 'package:mystocks/data/interface_intermediary.dart';
import 'package:mystocks/data/securities_price_info.dart';
import 'package:mystocks/libs/text_utils.dart';
import 'package:mystocks/screens/add_user_securities.dart';
import 'package:mystocks/screens/stock_info_screen.dart';
import 'package:sprintf/sprintf.dart';

class StocksListScreen extends State<MyStocksListPage>
    implements ISecuritiesUpdate {
  late Timer _timer;
  late SecuritiesDataUpdater _securitiesDataUpdater;

  @override
  void initState() {
    super.initState();
    var intermediary = widget.services.getService<IIntermediary>();
    _securitiesDataUpdater =
        SecuritiesDataUpdater(intermediary);
    _securitiesDataUpdater.setPriceListener(this);
    startTimer();
  }

  void startTimer() async {
    var userSecurities = widget.services.getService<IUserSecurities>();
    _securitiesDataUpdater
        .setSecuritiesNames(userSecurities.userSecurities);
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

      var psCollection = widget.services.getService<IPurchasedSecuritiesCollection>();
      //var listCollection = widget.services.purchasedSecuritiesCollection;
      var listSec = psCollection.getListSecurities(secPrice.tickerSymbol);

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

      price = "${TextUtils.insertSpacesInThousands(currentPriceSec)} p";
      currentPriceMy = "${TextUtils.insertSpacesInThousands(myAllPriceSec)} p";

      priceIfBy = "${TextUtils.insertSpacesInThousands(canAllPriceSec)} p";
      priceDifferenceString =
          "${TextUtils.insertSpacesInThousands(priceDifference)} p";
      percentDifferenceString = sprintf('%.1f %', [percentDifference]);
    }

    var color = isGrowthUp ? Colors.green : Colors.deepOrange;

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.green,
      ),
      onDismissed: (DismissDirection direction) async{
        var userSecurities = widget.services.getService<IUserSecurities>();
        userSecurities.removeItem(secName);
        _securitiesDataUpdater
            .setSecuritiesNames(userSecurities.userSecurities);
        await userSecurities.save();
        onUpdateSecuritiesPrice();
      },
      child: GestureDetector(
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
                CircleAvatar(
                    child: Text(
                  secName,
                  style: const TextStyle(fontSize: 10),
                )),
                const SizedBox(width: 10),
                SizedBox(
                  width: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text(secName), Text(price)],
                  ),
                ),
                SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text(currentPriceMy), Text(priceIfBy)],
                    )),
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
          )),
    );
  }

  Widget _buildHeader(BuildContext context) {
    String sumPriceAllMySecStr = "---";
    String sumPriceAllSecToStockExchangeStr = "---";
    String diffBayedAndCurrentPriceSecStr = "---";
    String diffBayedAndCurrentPricePercentStr = "---";

    var psCollection = widget.services.getService<IPurchasedSecuritiesCollection>();
    //var psCollection = widget.services.purchasedSecuritiesCollection;
    var sumPriceAllMySec = psCollection.getAllPurchasedSecuritiesPrice();

    var listAllMySec = psCollection.getAllSecurities();

    double sumPriceAllSecToStockExchange = 0;
    for (var sec in listAllMySec) {
      var count = sec.getCountAllSecurities();
      var securities = _securitiesDataUpdater.getPriceByName(sec.tickerSymbol);
      if (securities != null) {
        sumPriceAllSecToStockExchange += securities.currentPrice! * count;
      }
    }

    sumPriceAllMySecStr =
        "${TextUtils.insertSpacesInThousands(sumPriceAllMySec)} p";
    sumPriceAllSecToStockExchangeStr =
        "${TextUtils.insertSpacesInThousands(sumPriceAllSecToStockExchange)} p";

    double diffBayedAndCurrentPriceSec =
        (sumPriceAllSecToStockExchange - sumPriceAllMySec);
    diffBayedAndCurrentPriceSecStr =
        "${TextUtils.insertSpacesInThousands(diffBayedAndCurrentPriceSec)} p";

    diffBayedAndCurrentPricePercentStr = sprintf('%.1f %',
        [(diffBayedAndCurrentPriceSec / sumPriceAllSecToStockExchange) * 100]);

    var color =
        diffBayedAndCurrentPriceSec > 0 ? Colors.green : Colors.deepOrange;

    /*
    return Container(
      color: Colors.green,
    );
     */

    /*
    return Row(
      children: [
        Expanded(child: Container(
          color: Colors.green,
        )),
        Expanded(child: Container(
          color: Colors.red,
        )),
        Expanded(child: Container(
          color: Colors.white,
        )),
      ],
    );
     */

    return Row(
      children: [
        const SizedBox(height: 100),
        Expanded(
            child: Text(
          sumPriceAllMySecStr,
          textAlign: TextAlign.center,
        )),
        Expanded(
            child: Text(sumPriceAllSecToStockExchangeStr,
                textAlign: TextAlign.center)),
        Expanded(
            child: Text(
          diffBayedAndCurrentPriceSecStr,
          textAlign: TextAlign.center,
          style: TextStyle(color: color),
        )),
        Expanded(
            child: Text(
          diffBayedAndCurrentPricePercentStr,
          textAlign: TextAlign.center,
          style: TextStyle(color: color),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) =>
                  AddUserSecuritiesScene(title: "", services: widget.services),
            ),
          )
              .then((value) async {
            var us = widget.services.getService<IUserSecurities>();
           // var listSen = widget.services.userSecurities;
            _securitiesDataUpdater.setSecuritiesNames(us.userSecurities);
            await us.save();
            setState(
              () {},
            );
          });
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        // title: const Text("My Stock"),
        title: _buildHeader(context),
        //flexibleSpace: _buildHeader(context),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              // padding: const EdgeInsets.all(8),
              itemCount: _securitiesDataUpdater.countSecurities(),
              itemBuilder: (context, index) {
                return _buildListItem(index);
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(height: 4),
            ),
          ),
        ],
      ),
    );
  }
}

class MyStocksListPage extends StatefulWidget {
  final IServicesCollection services;

  const MyStocksListPage(
      {super.key, required this.title, required this.services});

  final String title;

  @override
  State<MyStocksListPage> createState() => StocksListScreen();
}
