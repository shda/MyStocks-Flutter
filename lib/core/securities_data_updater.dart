import 'dart:collection';

import '../data/securities_price_info.dart';
import '../moex/moex_intermediary_impl.dart';
import 'intermediary.dart';

class SecuritiesDataUpdater {
  late ISecuritiesUpdate? _securitiesUpdate;
  late Intermediary _intermediary;
  late HashSet<String> _securitiesUpdateNames;
  late Map<String, SecuritiesPriceInfo> _securitiesPriceDict;
  late bool _isRequestInProcess;

  SecuritiesDataUpdater() {
    _intermediary = Intermediary(MoexIntermediaryImpl());
    _securitiesUpdateNames = HashSet<String>.identity();
    _securitiesPriceDict = Map<String, SecuritiesPriceInfo>.identity();
    _isRequestInProcess = false;
  }

  int countSecurities() => _securitiesUpdateNames.length;

  SecuritiesPriceInfo? getPrice(int index) {
    List<SecuritiesPriceInfo> sen =
        List<SecuritiesPriceInfo>.from(_securitiesPriceDict.values);
    if (sen.length <= index) {
      return null;
    }
    return sen[index];
  }

  void setPriceListener(ISecuritiesUpdate securitiesUpdate) {
    _securitiesUpdate = securitiesUpdate;
  }

  void requestSecurities() {
    if (_isRequestInProcess) {
      return;
    }

    _requestSecuritiesAsync();
  }

  void setSecuritiesNames(Iterable<String> secUid) {
    for (var id in secUid) {
      _securitiesUpdateNames.add(id);
    }
  }

  void _requestSecuritiesAsync() async {
    _isRequestInProcess = true;

    if (_securitiesUpdateNames.isEmpty) {
      _isRequestInProcess = false;
      return;
    }

    var listPriceSecurities =
        await _intermediary.requestLastPrice(_securitiesUpdateNames);
    _securitiesPriceDict.clear();
    listPriceSecurities.forEach((key, value) {
      _securitiesPriceDict[key] = value;
    });

    _isRequestInProcess = false;

    _securitiesUpdate?.onUpdateSecuritiesPrice();
  }
}

abstract class ISecuritiesUpdate {
  void onUpdateSecuritiesPrice();
}
