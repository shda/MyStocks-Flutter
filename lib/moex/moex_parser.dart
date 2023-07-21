import 'dart:convert';
import 'package:mystocks/moex/marketdata_columns_enum.dart';
import 'package:mystocks/moex/moex_securities_info.dart';
import 'package:mystocks/moex/moex_security_metadata_info.dart';
import 'dart:developer' as developer;

class MoexParser {

  static Map<String, MoexSecuritiesInfo> parsingAllSecuritiesDict(
      String jsonData) {
    var mapJson = jsonDecode(jsonData);
    var table = mapJson["securities"]["data"];

    Map<String, MoexSecuritiesInfo> map =
      <String, MoexSecuritiesInfo>{};

    try {
      List<dynamic> list = table;

      for (int i = 0; i < list.length; i++) {
        List<dynamic> items = list[i];

        var info = MoexSecuritiesInfo(
          secId: items[SecuritiesFieldEnum.SECID.index],
          secName: items[SecuritiesFieldEnum.SECNAME.index],
          shortName: items[SecuritiesFieldEnum.SHORTNAME.index],
        );

        map[info.secId as String] = info;
      }
    } catch (e) {
      developer.log(e.toString());
    }

    return map;
  }

  static Map<String, MoexSecurityMetadataInfo> parsingMarketDict(
      String jsonData) {
    var mapJson = jsonDecode(jsonData);
    var table = mapJson["marketdata"]["data"];

    Map<String, MoexSecurityMetadataInfo> map =
        <String, MoexSecurityMetadataInfo>{};

    try {
      List<dynamic> list = table;

      for (int i = 0; i < list.length; i++) {
        List<dynamic> items = list[i];

        dynamic value = items[MarketdataColumnsEnum.LAST.index];
        value ??= items[MarketdataColumnsEnum.MARKETPRICE.index];

        double price = 0;

        if (value != null) {
          double? val = double.tryParse(value.toString());
          if (val != null) {
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
    } catch (e) {
      developer.log(e.toString());
    }

    return map;
  }
}
