import '../data/securities_price_info.dart';
import 'moex_security_metadata_info.dart';

class Converter
{
  static Map<String, SecuritiesPriceInfo> convert(Map<String, MoexSecurityMetadataInfo> dict) {
    return Map<String, SecuritiesPriceInfo>.identity();
  }
}