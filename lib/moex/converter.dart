import '../data/securities_info.dart';
import '../data/securities_price_info.dart';
import 'moex_securities_info.dart';
import 'moex_security_metadata_info.dart';

class Converter {
  static Map<String, SecuritiesPriceInfo> convert(Map<String, MoexSecurityMetadataInfo> dict) {
    Map<String, SecuritiesPriceInfo> result = {};
    dict.forEach((key, value) {
      result[key] = SecuritiesPriceInfo(
        currentPrice: value.last,
        tickerSymbol: value.secId,
        time: value.sysTime,
      );
    });

    return result;
  }

  static Map<String, SecuritiesInfo> convertInfo(Map<String, MoexSecuritiesInfo> dict) {
    Map<String, SecuritiesInfo> result = {};
    dict.forEach((key, value) {
      result[key] = SecuritiesInfo(
        shortName: value.shortName,
        tickerSymbol: value.secId,
        fullName: value.secName,
      );
    });

    return result;
  }
}