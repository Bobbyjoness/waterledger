import "package:flutter/material.dart";
import 'package:waterledger/constants/constants.dart';
import 'package:flutter_redux/flutter_redux.dart';

//My Code
import "package:waterledger/historyChart.dart";
import 'package:waterledger/models/appState.dart';
import 'package:waterledger/viewModels/historyChartViewModel.dart';

class HistoryChartWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryChartState();
  }
}

class _HistoryChartState extends State<HistoryChartWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Amount of water consumed per day."),
            subtitle: StoreConnector<AppState, HistoryChartViewModel>(
                converter: (store) => HistoryChartViewModel.fromStore(store),
                builder: (context, viewModel) =>
                    Text("(" + viewModel.timeSpanString + ")")),
          ),
          Container(
            width: 250,
            height: 250,
            child: StoreConnector<AppState, HistoryChartViewModel>(
                converter: (store) => HistoryChartViewModel.fromStore(store),
                builder: (context, viewModel) =>
                    TimeSeriesBar(viewModel.dataPoints)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StoreConnector<AppState, HistoryChartViewModel>(
                converter: (store) => HistoryChartViewModel.fromStore(store),
                builder: (context, viewModel) => DropdownButton(
                      value: viewModel.timeSpan,
                      items: [
                        DropdownMenuItem(
                          child: Text("Last 7 days"),
                          value: TimeSpan.WEEK,
                        ),
                        DropdownMenuItem(
                          child: Text("Last 30 days"),
                          value: TimeSpan.MONTH,
                        ),
                        DropdownMenuItem(
                          child: Text("Last 90 days"),
                          value: TimeSpan.QUARTER,
                        ),
                        DropdownMenuItem(
                          child: Text("Last Year"),
                          value: TimeSpan.YEAR,
                        ),
                        DropdownMenuItem(
                          child: Text("Since Beginning"),
                          value: TimeSpan.FOREVER,
                        ),
                      ],
                      onChanged: (value) => viewModel.onTimeSpanChange(value),
                    ),
              )
            ],
          )
        ],
      ),
    );
  }
}
