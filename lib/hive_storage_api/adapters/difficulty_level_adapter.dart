import 'package:hive/hive.dart';
import 'package:word_storage_api/word_storage_api.dart';

//Warning: do not change adapters
class DifficultyLevelAdapter extends TypeAdapter<DifficultyLevel> {
  @override
  final int typeId = 100;

  @override
  DifficultyLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DifficultyLevel.none;
      case 1:
        return DifficultyLevel.easy;
      case 2:
        return DifficultyLevel.medium;
      case 3:
        return DifficultyLevel.hard;
      default:
        return DifficultyLevel.none;
    }
  }

  @override
  void write(BinaryWriter writer, DifficultyLevel obj) {
    switch (obj) {
      case DifficultyLevel.none:
        writer.writeByte(0);
        break;
      case DifficultyLevel.easy:
        writer.writeByte(1);
        break;
      case DifficultyLevel.medium:
        writer.writeByte(2);
        break;
      case DifficultyLevel.hard:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DifficultyLevelAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
