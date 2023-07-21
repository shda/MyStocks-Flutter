import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mystocks/core/interfaces/interface_user_securities.dart';
import 'package:path_provider/path_provider.dart';

class UserSecurities extends IUserSecurities{

  final HashSet<String> _userSecurities = HashSet<String>.identity();

  @override
  Iterable<String> get userSecurities => _userSecurities;

  @override
  void addItem(String item){
    _userSecurities.add(item);
  }

  @override
  void removeItem(String item){
    _userSecurities.removeWhere((element) => element == item);
  }

  Future<String> get _localPath async {
    WidgetsFlutterBinding.ensureInitialized();
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user_securities.txt');
  }

  @override
  Future load() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final list = jsonDecode(contents) as List<dynamic>;
      for (var element in list) {
        _userSecurities.add(element as String);
      }

    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Map<String, dynamic> toJson() => {'userSecurities': _userSecurities};

  @override
  Future save() async {
    final file = await _localFile;
    var list = _userSecurities.toList();
    final json = jsonEncode(list);
    file.writeAsString(json);
  }
}