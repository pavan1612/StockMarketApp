import 'dart:convert';
import 'package:Fintech/models/quote.dart';
import 'package:Fintech/models/stock.dart';
import 'package:Fintech/models/time_series_prices.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:Fintech/config.dart';

class ChartData {
  final client = http.Client();
  var priceUpdate = new Map<Stock, Quote>();
  IOWebSocketChannel channel;

  Future getCandles(String symbol, String resolution, DateTime from,
      DateTime to, String exchange) async {
    final api = url +
        '/' +
        exchange +
        '/candle?symbol=' +
        symbol +
        '&resolution=' +
        resolution +
        '&from=' +
        (from.millisecondsSinceEpoch / 1000).toStringAsFixed(0) +
        '&to=' +
        (to.millisecondsSinceEpoch / 1000).toStringAsFixed(0) +
        '&token=' +
        token;
    final response = await client.get(api);

    if (response.statusCode == 200) {
      var candlesMap = json.decode(response.body) as Map;
      List priceList = candlesMap['c'];
      List timeList = candlesMap['t'];

      List<TimeSeriesPrices> data = [];
      for (int i = 0; i < priceList.length; i++) {
        var entry;
        DateTime time = DateTime.fromMillisecondsSinceEpoch(timeList[i] * 1000);
        double price = double.parse(priceList[i].toString());
        entry = new TimeSeriesPrices(time, price);
        data.add(entry);
      }
      return data;
    }
  }
}
