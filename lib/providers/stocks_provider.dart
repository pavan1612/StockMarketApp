import 'package:Fintech/modals/stock.dart';
import 'package:Fintech/data.dart';
import 'dart:convert';
import 'package:Fintech/modals/quote.dart';
import 'package:Fintech/modals/stock.dart';
import 'package:Fintech/modals/time_series_prices.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:Fintech/config.dart';

class StocksProvider with ChangeNotifier {
  //Variables
  List<Stock> _stocks = [];
  String initialExchange = 'crypto';
  final client = http.Client();
  List<Quote> priceUpdate = [];
  IOWebSocketChannel channel;

  //Initialising /Constructor
  StocksProvider() {
    channel = IOWebSocketChannel.connect(webSocketURL + token);
    all.forEach((element) {
      _stocks.add(Stock(element['description'], element['symbol'],
          element['currency'], element['type'], element['logo']));
    });

    _stocks.forEach((element) async {
      priceUpdate.add(await fetchStockPrice(element.symbol));
      channel.sink
          .add(jsonEncode({'type': 'subscribe', 'symbol': element.symbol}));
    });

    channel.stream.listen((response) {
      var parsedResponse = json.decode(response) as Map;
      if (parsedResponse['type'] != 'ping') {
        Map currentPrices = parsedResponse['data'][0];

        int index = _stocks
            .indexWhere((element) => element.symbol == currentPrices['s']);
        Stock currentStock = _stocks.elementAt(index);

        priceUpdate.forEach((element) {
          if (element.stockSymbol == currentStock.symbol) {
            element.currentPrice = currentPrices['p'].toString();
          }
        });
      }
    });
  }
  //Providers
  List<Stock> get stocks => _stocks;
  String get exchange => initialExchange;
  Stream<List> get stockPrices async* {
    yield priceUpdate;
  }

  void setExchange(String exchange) {
    initialExchange = exchange;
    notifyListeners();
  }

  //Setters

  void searchStocks(String value) {
    _stocks = [];
    all
        .where((element) => element['description'].contains(value))
        .forEach((element) {
      _stocks.add(Stock(element['description'], element['symbol'],
          element['currency'], element['type'], element['logo']));
    });
    initialExchange = 'all';
  }

  Future fetchStockPrice(String symbol) async {
    final api = "/quote?symbol=" + symbol + "&token=";
    final apiURL = url + api + token;
    final response = await client.get(apiURL);
    if (response.statusCode == 200) {
      var priceMap = json.decode(response.body) as Map;
      return Quote(
          symbol,
          priceMap['o'].toString(),
          priceMap['h'].toString(),
          priceMap['l'].toString(),
          priceMap['c'].toString(),
          priceMap['p'].toString());
    } else {
      return Exception("Failed to load");
    }
  }
}
