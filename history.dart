import "package:flutter/material.dart";
import 'package:flutter_redux/flutter_redux.dart';

//my code
import "package:waterledger/buymecoffee.dart";
import "package:waterledger/historyChartManager.dart";
import 'package:waterledger/models/appState.dart';
import 'package:waterledger/viewModels/historyViewModel.dart';

//Class is done for now.

class HistoryWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        HistoryChartWidget(),
        Card(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: StoreConnector<AppState, HistoryViewModel>(
                    converter: (store) => HistoryViewModel.fromStore(store),
                    builder: (context, viewModel) => Text(
                        viewModel.dailyAverageForever.toStringAsFixed(1) +
                            " " +
                            viewModel.unitsString),
                  ),
                  subtitle: Text("Daily Average Intake(All Time)"),
                ),
                ListTile(
                  title: StoreConnector<AppState, HistoryViewModel>(
                    converter: (store) => HistoryViewModel.fromStore(store),
                    builder: (context, viewModel) => Text(
                        viewModel.dailyAverageWeekly.toStringAsFixed(1) +
                            " " +
                            viewModel.unitsString),
                  ),
                  subtitle: Text("Daily Average Intake(Week)"),
                ),
                ListTile(
                  title: StoreConnector<AppState, HistoryViewModel>(
                    converter: (store) => HistoryViewModel.fromStore(store),
                    builder: (context, viewModel) => Text(
                        viewModel.beverageAmountAverage.toStringAsFixed(1) +
                            " " +
                            viewModel.unitsString),
                  ),
                  subtitle: Text("Average Beverage Size"),
                ),
              ],
            ),
          ),
        ),
        BMCWidget()
      ],
    );
  }
}
