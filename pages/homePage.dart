import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:waterledger/daily.dart';
import 'package:waterledger/history.dart';
import 'package:waterledger/models/appState.dart';
import 'package:waterledger/models/drinkEntry.dart';
import 'package:waterledger/settings.dart';
import 'package:waterledger/viewModels/generalViewModel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController controller;
  List<WaterEntry> entries;

  @override
  void initState() {
    entries = [];
    controller = TabController(length: 3, vsync: this);
    controller
        .addListener(() => FocusScope.of(context).requestFocus(FocusNode()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        floatingActionButton: StoreConnector<AppState, GeneralViewModel>(
            converter: (store) => GeneralViewModel.fromStore(store),
            builder: (BuildContext context, GeneralViewModel viewModel) {
              return FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () => viewModel.onAddPressed());
            }),
        appBar: AppBar(
          title: Text("WaterLedger"),
          bottom: TabBar(
            controller: controller,
            tabs: <Widget>[
              Tab(child: Text("Daily")),
              Tab(child: Text("History")),
              Tab(child: Text("Settings")),
            ],
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: [
            DailyWidget(),
            HistoryWidget(),
            SettingsWidget(),
          ],
        ),
      ),
    );
  }
}
