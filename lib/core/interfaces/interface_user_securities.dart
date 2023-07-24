import 'package:mystocks/core/services.dart';

abstract class IUserSecurities extends IService{

  Iterable<String> get userSecurities;

  void addItem(String item);
  void removeItem(String item);

  Future load();
  Future save();
}