import 'package:hive/hive.dart';
import 'package:word_storage_api/word_storage_api.dart';

//Warning: do not change adapters
class WordStatusAdapter extends TypeAdapter<WordStatus> {
  @override
  final int typeId = 104;

  @override
  WordStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return WordStatus.none;
      case 1:
        return WordStatus.accepted;
      case 2:
        return WordStatus.rejected;
      default:
        return WordStatus.none;
    }
  }

  @override
  void write(BinaryWriter writer, WordStatus obj) {
    switch (obj) {
      case WordStatus.none:
        writer.writeByte(0);
        break;
      case WordStatus.accepted:
        writer.writeByte(1);
        break;
      case WordStatus.rejected:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WordStatusAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
