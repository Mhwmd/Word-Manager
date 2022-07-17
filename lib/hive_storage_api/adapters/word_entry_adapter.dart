import 'package:hive/hive.dart';
import 'package:word_storage_api/word_storage_api.dart';

//Warning: do not change adapters
class WordEntryAdapter extends TypeAdapter<WordEntry> {
  @override
  final int typeId = 102;

  @override
  WordEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WordEntry(
      id: fields[0] as String,
      wordData: fields[1] as String,
      difficultyLevel: fields[2] as DifficultyLevel,
      wordStatus: fields[3] as WordStatus,
    );
  }

  @override
  void write(BinaryWriter writer, WordEntry obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.wordData)
      ..writeByte(2)
      ..write(obj.difficultyLevel)
      ..writeByte(3)
      ..write(obj.wordStatus);
  }

// @override
// int get hashCode => typeId.hashCode;
//
// @override
// bool operator ==(Object other) =>
//     identical(this, other) || other is WordEntryAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
