import 'dart:async';
import 'package:Fintech/data.dart';
import 'package:Fintech/models/quote.dart';
import 'package:web_socket_channel/io.dart';
import 'package:Fintech/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuotesProvider {
  List<Quote> priceUpdate;
  IOWebSocketChannel channel;
  final client = http.Client();
  StreamController<List<Quote>> streamController = StreamController();

  Stream<List<Quote>> get update => streamController.stream;

  QuotesProvider() {
    List<Quote> priceUpdate = [];
    priceUpdate = initQuote();
    streamController.add(List.from(priceUpdate));

    channel = IOWebSocketChannel.connect(webSocketURL + token);
    try {
      all.forEach((element) async {
        await fetchStockPrice(element['symbol'], priceUpdate);
        streamController.add(List.from(priceUpdate));
        channel.sink.add(
            jsonEncode({'type': 'subscribe', 'symbol': element['symbol']}));
      });
      // print('adding done');

      channel.stream.listen((response) {
        var parsedResponse = json.decode(response) as Map;
        if (parsedResponse['type'] != 'ping') {
          Map currentPrices = parsedResponse['data'][0];
          priceUpdate.forEach((element) {
            if (element.stockSymbol == currentPrices['s']) {
              element.setCurrentPrice(currentPrices['p'].toString());
            }
          });
          streamController.add(List.from(priceUpdate));
        }
      });
    } catch (err) {
      print(err);
    }
  }

  Future fetchStockPrice(String symbol, List priceUpdate) async {
    final api = "/quote?symbol=" + symbol + "&token=";
    final apiURL = url + api + token;
    final response = await client.get(apiURL);
    if (response.statusCode == 200) {
      // print('pricing');
      var priceMap = json.decode(response.body) as Map;
      priceUpdate.forEach((element) {
        if (element.stockSymbol == symbol) {
          element.openPrice = priceMap['o'].toString();
          element.highPrice = priceMap['h'].toString();
          element.lowPrice = priceMap['l'].toString();
          element.currentPrice = priceMap['c'].toString();
          element.previousClosePrice = priceMap['p'].toString();
          element.openPrice = priceMap['o'].toString();
        }
      });
    } else {
      return Exception("Failed to load");
    }
  }

  List<Quote> initQuote() {
    List<Quote> init = [];
    all.forEach((element) {
      init.add(new Quote(element['symbol'], '0', '0', '0', '0', '0'));
    });
    return init;
  }
}
