import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_word_manager/hive_storage_api/hive_storage_api.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:word_storage_repository/word_storage_repository.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory? dir = await path_provider.getExternalStorageDirectory();
  Hive.init(dir!.path);
  WordStorageRepository wordStorageRepository = WordStorageRepository(wordStorageApi: HiveStorageApi());
  bootstrap(wordStorageRepository: wordStorageRepository);
}

void bootstrap({required WordStorageRepository wordStorageRepository}) {
  FlutterError.onError = (details) {
    log("exception: ${details.exceptionAsString()}, stack trace: ${details.stack}");
  };

  runZonedGuarded(() => runApp(App(wordStorageRepository: wordStorageRepository)), (error, stack) {
    log("error: $error, stack trace: $stack");
  });
}
