import 'package:word_storage_api/word_storage_api.dart';

class WordStorageRepository {
  const WordStorageRepository({required WordStorageApi wordStorageApi}) : _wordStorageApi = wordStorageApi;
  final WordStorageApi _wordStorageApi;

  WordEntry get(String id) => _wordStorageApi.get(id);

  Stream<WordEntries> getWords() => _wordStorageApi.getWords();

  Future<void> save(WordEntry word) => _wordStorageApi.save(word);

  Future<WordEntry> remove(String id) => _wordStorageApi.remove(id);

  Future<void> removeAll([List<String>? ids]) => _wordStorageApi.removeAll(ids);

  Future<void> saveAll(WordEntries words) => _wordStorageApi.saveAll(words);
}
