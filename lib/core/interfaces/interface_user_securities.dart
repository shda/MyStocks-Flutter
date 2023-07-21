abstract class IUserSecurities{

  Iterable<String> get userSecurities;

  void addItem(String item);
  void removeItem(String item);

  Future load();
  Future save();
}