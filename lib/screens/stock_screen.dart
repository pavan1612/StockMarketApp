import 'package:Fintech/modals/stock.dart';
import 'package:Fintech/modals/time_series_prices.dart';
import 'package:Fintech/services/chart_data.dart';
import 'package:Fintech/widgets/stockspage/line_charts.dart';
import 'package:Fintech/widgets/stockspage/appbar.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StockScreen extends StatefulWidget {
  final Stock stock;

  StockScreen(this.stock);
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final finhub = new ChartData();
  String resolution = "60";
  DateTime pickedDate = DateTime.now().subtract(Duration(days: 1));

  Future fetchTimeSeriesData(symbol) async {
    switch (resolution) {
      case ('1'):
        pickedDate = DateTime.now().subtract(Duration(days: 1));
        break;

      case ('5'):
        pickedDate = DateTime.now().subtract(Duration(days: 2));
        break;
      case ('15'):
        pickedDate = DateTime.now().subtract(Duration(days: 5));
        break;
      case ('30'):
        pickedDate = DateTime.now().subtract(Duration(days: 30));
        break;
      case ('60'):
        pickedDate = DateTime.now().subtract(Duration(days: 180));
        break;
      case ('D'):
        pickedDate = DateTime.now().subtract(Duration(days: 365));
        break;
      case ('W'):
        pickedDate = DateTime.now().subtract(Duration(days: 730));
        break;
      case ('M'):
        pickedDate = DateTime.now().subtract(Duration(days: 2000));
        break;
    }
    final data = await finhub.getCandles(
        symbol, resolution, pickedDate, DateTime.now(), widget.stock.type);

    return await data;
  }

  List<charts.Series<TimeSeriesPrices, DateTime>> getChartData(data) {
    return [
      charts.Series<TimeSeriesPrices, DateTime>(
        id: 'Prices',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesPrices stocks, _) => stocks.getTime(),
        measureFn: (TimeSeriesPrices stocks, _) => stocks.getPrice(),
        data: data,
      )
    ];
  }

  Map<String, String> timeSeriesValues = {
    '1 Day': '1',
    '2 Days': '5',
    '5 Days': '15',
    '1 Month': '30',
    '6 Months': '60',
    '1 Year ': 'D',
    '2 Years': 'W',
    '5 Years': 'M'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.3),
            child: StockPageAppBar(widget.stock, finhub)),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: FutureBuilder(
                future: fetchTimeSeriesData(
                  widget.stock.symbol,
                ),
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.height * 0.9,
                                margin: EdgeInsets.all(5),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 8,
                                  itemBuilder: (context, index) => FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          resolution = timeSeriesValues[
                                              timeSeriesValues.keys
                                                  .toList()[index]];
                                        });
                                      },
                                      child: Text(
                                        timeSeriesValues.keys.toList()[index],
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                )),
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color: Theme.of(context).accentColor)),
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(5),
                                child: LineChart(getChartData(snapshot.data))),
                          ],
                        );
                }),
          ),
        ));
  }
}
