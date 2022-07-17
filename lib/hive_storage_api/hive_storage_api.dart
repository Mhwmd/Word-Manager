import 'dart:async';

import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:word_storage_api/word_storage_api.dart';

class HiveStorageApi extends WordStorageApi {
  HiveStorageApi() {
    _init();
  }

  static const String kBoxName = "words";
  final BehaviorSubject<List<WordEntry>> _streamBehavior = BehaviorSubject<List<WordEntry>>.seeded(const []);
  bool isBoxInitialized = false;
  late Box box;

  Future<void> _init() async {
    box = await Hive.openBox(kBoxName);
    isBoxInitialized = box.isOpen;

    _streamBehavior.add(_wordEntries);
  }

  List<WordEntry> get _wordEntries {
    return box.values.map((jsonMap) {
      return WordEntry.fromJson(JsonMap.from(jsonMap));
    }).toList();
  }

  @override
  WordEntry get(String id) {
    if (!box.containsKey(id)) throw WordIdNotExists();
    return WordEntry.fromJson(JsonMap.from(box.get(id)!));
  }

  @override
  Stream<List<WordEntry>> get stream {
    return _streamBehavior.asBroadcastStream();
  }

  @override
  Future<void> save(WordEntry word) async {
    await box.put(word.id, word.toJson());
    _streamBehavior.add(_wordEntries);
  }

  @override
  Future<WordEntry> remove(String id) async {
    if (!box.containsKey(id)) throw WordIdNotExists();
    WordEntry word = WordEntry.fromJson(JsonMap.from(box.get(id)!));

    await box.delete(id);
    _streamBehavior.add(_wordEntries);
    return word;
  }

  @override
  Future<void> removeAll([List<String>? ids]) async {
    if (ids != null && ids.isEmpty) return;
    if (ids != null) {
      await box.deleteAll(ids);
    } else {
      await box.clear();
    }
    _streamBehavior.add(_wordEntries);
  }

  @override
  Future<void> saveAll(WordEntries words) async {
    if (words.isEmpty) return;
    await box.putAll({for (var word in words) word.id: word.toJson()});
    _streamBehavior.add(_wordEntries);
  }
}

class WordIdNotExists implements Exception {}
