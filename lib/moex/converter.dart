import '../data/securities_price_info.dart';
import 'moex_security_metadata_info.dart';

class Converter
{
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
}