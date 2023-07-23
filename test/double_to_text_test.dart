import 'package:flutter_test/flutter_test.dart';
import 'package:mystocks/libs/text_utils.dart';

void main(){
  test("doubleToText_insertSpacesInThousands", ()  {
    expect(TextUtils.insertSpacesInThousands(123.0), "123.0");
    expect(TextUtils.insertSpacesInThousands(1234.0), "1 234.0");
    expect(TextUtils.insertSpacesInThousands(12345.0), "12 345.0");
    expect(TextUtils.insertSpacesInThousands(123456.0), "123 456.0");
    expect(TextUtils.insertSpacesInThousands(1000000.0), "1 000 000.0");
    expect(TextUtils.insertSpacesInThousands(0.1), "0.1");
  });
}