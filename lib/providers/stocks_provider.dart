import 'package:Fintech/models/stock.dart';
import 'package:Fintech/data.dart';
import 'package:flutter/material.dart';

class StocksProvider with ChangeNotifier {
  //Variables
  List<Stock> _stocks = [];
  String initialExchange = 'crypto';

  //Initialising /Constructor
  StocksProvider() {
    all.forEach((element) {
      _stocks.add(Stock(element['description'], element['symbol'],
          element['currency'], element['type'], element['logo']));
    });
  }
  //Providers
  List<Stock> get stocks => _stocks;
  String get exchange => initialExchange;

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
}
