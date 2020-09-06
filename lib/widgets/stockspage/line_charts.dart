/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class LineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  LineChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: true,
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      behaviors: [new charts.PanAndZoomBehavior()],
    );
  }
}
