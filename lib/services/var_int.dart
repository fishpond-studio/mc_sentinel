class VarInt {
  static const int varintFix = 0x80;

  static List<int> encode(int value) {
    // Ensure it's treated as a 32-bit signed integer first
    value = value.toSigned(32);

    final bytes = <int>[];

    // Use an unsigned representation for the bit manipulation
    int uValue = value & 0xFFFFFFFF;

    while (uValue >= 0x80) {
      bytes.add((uValue & 0x7F) | 0x80);
      uValue >>>= 7; // Use logical shift
    }

    bytes.add(uValue & 0x7F);
    return bytes;
  }

  static int decode(List<int> data) {
    int result = 0;
    int offset = 0;

    for (int i = 0; i < data.length; i++) {
      final byte = data[i];

      result |= (byte & 0x7F) << offset;

      if ((byte & varintFix) == 0) {
        if (result < -2147483648 || result > 2147483647) {
          throw Exception('VarInt out of 32-bit signed integer range');
        }
        return result;
      }
      offset += 7;
    }
    throw Exception('Incomplete VarInt');
  }

  static int getVarIntLength(List<int> data, {int index = 0}) {
    const maxVarIntBytes = 5;
    for (var i = 0; i < maxVarIntBytes && index + i < data.length; i++) {
      if ((data[index + i] & 0x80) == 0) return i + 1;
    }
    throw ArgumentError('VarInt is too long or incomplete.');
  }
}
