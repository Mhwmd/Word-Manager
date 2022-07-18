import 'dart:async';

import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:word_storage_api/word_storage_api.dart';

import 'adapters/adapters.dart';

class HiveStorageApi extends WordStorageApi {
  HiveStorageApi() {
    _init();
  }

  static const String kBoxName = "word_box";

  final BehaviorSubject<WordEntries> _streamBehavior = BehaviorSubject.seeded(const []);
  bool isBoxInitialized = false;
  late Box<WordEntry> box;

  Future<void> _init() async {
    Hive.registerAdapter(DifficultyLevelAdapter());
    Hive.registerAdapter(WordStatusAdapter());
    Hive.registerAdapter(WordEntryAdapter());

    box = await Hive.openBox<WordEntry>(kBoxName);
    isBoxInitialized = box.isOpen;

    _streamBehavior.add(_words);
  }

  // TODO: use iterable directly
  WordEntries get _words => box.values.toList();

  @override
  WordEntry get(String id) {
    if (!box.containsKey(id)) throw WordIdNotExists();
    return box.get(id)!;
  }

  @override
  Stream<WordEntries> get stream {
    return _streamBehavior.asBroadcastStream();
  }

  @override
  Future<void> save(WordEntry word) async {
    await box.put(word.id, word);
    _streamBehavior.add(_words);
  }

  @override
  Future<WordEntry> remove(String id) async {
    if (!box.containsKey(id)) throw WordIdNotExists();
    WordEntry word = box.get(id)!;

    await box.delete(id);
    _streamBehavior.add(_words);
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
    _streamBehavior.add(_words);
  }

  @override
  Future<void> saveAll(WordEntries words) async {
    if (words.isEmpty) return;
    await box.putAll({for (var word in words) word.id: word});

    _streamBehavior.add(_words);
  }
}

class WordIdNotExists implements Exception {}
