class VarInt {
  static const int varintFix = 0x80;

  static List<int> encode(int value) {
    assert(
      value >= -2147483648 && value <= 2147483647,
      'Value must be a 32-bit signed integer',
    );

    final bytes = <int>[];

    while (value >= varintFix) {
      bytes.add((value & 0x7F) | varintFix);
      value >>= 7;
    }

    bytes.add(value & 0x7F);
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
