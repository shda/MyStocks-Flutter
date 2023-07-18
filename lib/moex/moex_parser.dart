import 'dart:convert';
import 'package:mystocks/moex/marketdata_columns_enum.dart';
import 'package:mystocks/moex/moex_security_metadata_info.dart';

class MoexParser {

  static Map<String, MoexSecurityMetadataInfo> parsingMarketDict(String jsonData) {
    var mapJson = jsonDecode(jsonData);
    var table = mapJson["marketdata"]["data"];

    Map<String, MoexSecurityMetadataInfo> map = <String, MoexSecurityMetadataInfo>{};

    List<dynamic> list = table;

    for(int i=0; i < list.length ; i++){
      List<dynamic> items = list[i];

      dynamic value = items[MarketdataColumnsEnum.LAST.index];
      value ??= items[MarketdataColumnsEnum.MARKETPRICE.index];

      double price = 0;

      if(value != null){
        double? val = double.tryParse(value.toString());
        if(val != null){
          price = val;
        }
      }

      var info = MoexSecurityMetadataInfo(
        secId: items[MarketdataColumnsEnum.SECID.index],
        last: price,
        sysTime: items[MarketdataColumnsEnum.TIME.index],
      );

      map[info.secId as String] = info;
    }

    return map;
  }
}