import "package:flutter/material.dart";
import "package:charts_flutter/flutter.dart" as charts;

class TimeSeriesBar extends StatelessWidget {
  final List<charts.Series<TimeSeriesProgress, DateTime>> seriesList;
  final bool animate;

  TimeSeriesBar._(this.seriesList, {this.animate});

  factory TimeSeriesBar(List<Map<String, dynamic>> data) {
    return new TimeSeriesBar._(
      _createData(data),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      defaultRenderer: new charts.BarRendererConfig<DateTime>(),
      defaultInteractions: false,
      behaviors: [new charts.SelectNearest(), new charts.DomainHighlighter()],
    );
  }

  static List<charts.Series<TimeSeriesProgress, DateTime>> _createData(
      List<Map<String, dynamic>> input) {
    final data = input
        .map((element) =>
            TimeSeriesProgress(element["date"], element["progress"]))
        .toList();

    return [
      new charts.Series<TimeSeriesProgress, DateTime>(
        id: 'Progress',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesProgress progress, _) => progress.time,
        measureFn: (TimeSeriesProgress progress, _) => progress.percent,
        data: data,
      )
    ];
  }
}

class TimeSeriesProgress {
  final DateTime time;
  final int percent;

  TimeSeriesProgress(this.time, this.percent);
}
