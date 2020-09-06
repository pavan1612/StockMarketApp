import 'dart:convert';
import 'package:Fintech/modals/quote.dart';
import 'package:Fintech/modals/stock.dart';
import 'package:Fintech/modals/time_series_prices.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:Fintech/data.dart';

class Finhub {
  final url = "https://finnhub.io/api/v1";
  final token = "bsf3q2frh5rbsaf4c8p0"; //bt66ff748v6oi7tnpdu0
  final client = http.Client();
  final webSocketURL = 'wss://ws.finnhub.io?token=';
  var priceUpdate = new Map<Stock, Quote>();
  IOWebSocketChannel channel;

  List<Stock> fetchStocks(String exchange) {
    List<Stock> stocks = [];
    switch (exchange) {
      case 'US':
        stocksUS.forEach((element) {
          stocks.add(Stock(element['description'], element['symbol'],
              element['currency'], element['type'], element['logo']));
        });
        break;
      case 'crypto':
        crypto.forEach((element) {
          stocks.add(Stock(element['description'], element['symbol'],
              element['currency'], element['type'], element['logo']));
        });
        break;
      case 'forex':
        forex.forEach((element) {
          stocks.add(Stock(element['description'], element['symbol'],
              element['currency'], element['type'], element['logo']));
        });
        break;
      case 'all':
        all.forEach((element) {
          stocks.add(Stock(element['description'], element['symbol'],
              element['currency'], element['type'], element['logo']));
        });
        break;
      default:
    }
    return stocks;
  }

  Stream fetchRealTimeExchangePrice(List<Stock> exchange) async* {
    //dont remove the below line from here
    channel = IOWebSocketChannel.connect(webSocketURL + token);
    try {
      exchange.forEach((element) async {
        channel.sink
            .add(jsonEncode({'type': 'subscribe', 'symbol': element.symbol}));

        priceUpdate[element] = await fetchStockPrice(element.symbol);
      });
      channel.stream.listen((response) {
        var parsedResponse = json.decode(response) as Map;
        if (parsedResponse['type'] != 'ping') {
          Map currentPrices = parsedResponse['data'][0];

          int index = exchange
              .indexWhere((element) => element.symbol == currentPrices['s']);
          Stock currentStock = exchange.elementAt(index);

          if (priceUpdate.containsKey(currentStock)) {
            priceUpdate.update(currentStock, (value) {
              value.currentPrice = currentPrices['p'].toString();
              return value;
            });
          }
        }
      });
    } catch (err) {
      print(err);
    }
    while (true) {
      await Future.delayed(Duration(seconds: 2));

      yield priceUpdate;
    }
  }

  Future fetchStockPrice(String symbol) async {
    final api = "/quote?symbol=" + symbol + "&token=";
    final apiURL = url + api + token;
    final response = await client.get(apiURL);
    if (response.statusCode == 200) {
      var priceMap = json.decode(response.body) as Map;
      return Quote(
          priceMap['o'].toString(),
          priceMap['h'].toString(),
          priceMap['l'].toString(),
          priceMap['c'].toString(),
          priceMap['p'].toString());
    } else {
      return Exception("Failed to load");
    }
  }

  Stream fetchRealTimeStockPrice(Stock stock) async* {
    while (true) {
      if (priceUpdate.containsKey(stock)) {
        yield (priceUpdate[stock]).currentPrice;
      }
      await Future.delayed(Duration(seconds: 1));
    }
  }

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

  List<Stock> searchStocks(String value) {
    List<Stock> stocks = [];
    all
        .where((element) => element['description'].contains(value))
        .forEach((element) {
      stocks.add(Stock(element['description'], element['symbol'],
          element['currency'], element['type'], element['logo']));
    });
    print('searching');
    return stocks;
  }
}
