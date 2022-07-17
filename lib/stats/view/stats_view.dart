import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_word_manager/extensions/extensions.dart';
import 'package:flutter_word_manager/stats/bloc/stats_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:word_storage_api/word_storage_api.dart';

class StatsView extends StatelessWidget {
  const StatsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statics"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<StatsBloc, StatsState>(builder: (context, state) {
          final JsonMap analysis = state.stats;
          if (state.status == StatsStatus.loading || state.status == StatsStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == StatsStatus.failure) {
            return const Center(child: Text("Failed to get data."));
          }
          return Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text("count"),
                      const SizedBox(height: 10),
                      Text(
                        "${state.wordsCount}",
                        style: const TextStyle(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Difficulty level: "),
                      Row(
                        children: [
                          SizedBox.square(
                            dimension: 180,
                            child: SfCircularChart(series: <CircularSeries>[
                              RadialBarSeries<DifficultyLevel, DifficultyLevel>(
                                maximumValue: 1,
                                dataSource: DifficultyLevel.values,
                                pointColorMapper: (DifficultyLevel difficultyLevel, _) => difficultyLevel.color,
                                xValueMapper: (DifficultyLevel difficultyLevel, _) => difficultyLevel,
                                yValueMapper: (DifficultyLevel difficultyLevel, _) =>
                                    analysis["difficultyPercentage"][difficultyLevel]["count"],
                                cornerStyle: CornerStyle.bothCurve,
                                gap: '8%',
                              )
                            ]),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: List.generate(DifficultyLevel.values.length, (index) {
                                  final DifficultyLevel current = DifficultyLevel.values[index];
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(10),
                                            width: 10,
                                            height: 10,
                                            color: current.color,
                                          ),
                                          Text(current.name)
                                        ],
                                      ),
                                      Text(
                                          "${(analysis['difficultyPercentage']![current]['count'] * 100 as double).toStringAsFixed(2)}%"),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Word status: "),
                      Row(
                        children: [
                          SizedBox.square(
                            dimension: 180,
                            child: SfCircularChart(series: <CircularSeries>[
                              RadialBarSeries<WordStatus, WordStatus>(
                                maximumValue: 1,
                                dataSource: WordStatus.values,
                                pointColorMapper: (WordStatus wordStatus, _) => wordStatus.color,
                                xValueMapper: (WordStatus wordStatus, _) => wordStatus,
                                yValueMapper: (WordStatus wordStatus, _) =>
                                    analysis["statusPercentage"][wordStatus]["count"],
                                cornerStyle: CornerStyle.bothCurve,
                                gap: '8%',
                              )
                            ]),
                          ),
                          Expanded(
                            child: Column(
                              children: List.generate(WordStatus.values.length, (index) {
                                final WordStatus current = WordStatus.values[index];
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          width: 10,
                                          height: 10,
                                          color: current.color,
                                        ),
                                        Text(current.name)
                                      ],
                                    ),
                                    Text(
                                        "${(analysis['statusPercentage'][current]['count'] * 100 as double).toStringAsFixed(2)}%"),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
