import 'models/word_entry.dart';
import 'types/types.dart';

abstract class WordStorageApi {
  const WordStorageApi();

  Stream<WordEntries> get stream;

  WordEntry get(String id);

  Future<WordEntry> remove(String id);

  Future<void> save(WordEntry word);

  Future<void> removeAll([List<String>? ids]);

  Future<void> saveAll(WordEntries words);
}
