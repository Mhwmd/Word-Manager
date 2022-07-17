import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_storage_repository/word_storage_repository.dart';

import 'home/view/home_page.dart';

class App extends StatelessWidget {
  const App({Key? key, required this.wordStorageRepository}) : super(key: key);
  final WordStorageRepository wordStorageRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: wordStorageRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const HomePage(),
    );
  }
}
