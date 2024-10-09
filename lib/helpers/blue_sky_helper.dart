import 'dart:typed_data';

abstract class BlueSkyHelper {
  static int calculateCheckByte({required Uint8List message}) {
    int xorResult = 0;
    for (int i = 0; i < message.length - 1; i++) {
      xorResult ^= message[i];
    }
    if (xorResult >= 128) {
      xorResult = xorResult - 128;
    }
    return xorResult;
  }

  static bool xorCheckByte({required Uint8List response}) {
    var xorResult = 0;
    for (int i = 0; i < response.length - 1; i++) {
      xorResult ^= response[i];
    }
    if (xorResult >= 128) {
      xorResult = xorResult - 128;
    }
    return xorResult == response[response.length - 1] ? true : false;
  }

  static double bcdToDouble(Uint8List bcdBytes, int bytes) {
    StringBuffer decimalString = StringBuffer();

    // Loop through 6 bytes for the BCD value
    for (int i = 0; i < bytes; i++) {
      int highNibble = (bcdBytes[i] >> 4) & 0x0F; // Get the high nibble
      int lowNibble = bcdBytes[i] & 0x0F; // Get the low nibble

      // Append the decimal digits to the string
      decimalString.write(highNibble);
      decimalString.write(lowNibble);
    }
    // Convert to double
    return double.parse(decimalString.toString());
  }

 static Uint8List calculateContent({required double value, required int bytes}) {
    Uint8List contentRequest = Uint8List(bytes);
    int d1 = value.toInt();
    for (int i = 0; i < bytes; i++) {
      int d3 = d1 % 100;
      int d2 = d3 ~/ 10;
      d2 = d2 * 16 + (d3 % 10);
      contentRequest[bytes - i - 1] = d2;

      d1 = d1 ~/ 100;

    }
    return contentRequest;
  }
}
