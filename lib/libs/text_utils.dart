import 'package:flutter/widgets.dart';
import 'package:sprintf/sprintf.dart';

class TextUtils{
  static String insertSpacesInThousands(double number ,{int countAfterDot = 1}){
    String numberString = sprintf('%.${countAfterDot}f', [number]);
    var chars = numberString.characters.toList();
    String retString = "";
    bool isFindDot = false;
    int offset = 3;
    for(int i = chars.length - 1 ; i >= 0 ; i--){

      String char = chars[i];
      retString += char;

      if(char == '.'){
        isFindDot = true;
        offset = 4;
      }

      offset--;

      if(isFindDot && offset == 0 && i > 0){
        retString +=" ";
        offset = 3;
      }
    }

    String revertString = "";
    var listRevert = retString.characters.toList();
    for(int i = retString.length - 1 ; i >= 0 ; i--){
      revertString += listRevert[i];
    }

    return revertString;
  }
}