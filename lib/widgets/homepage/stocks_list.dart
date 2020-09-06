import 'package:Fintech/modals/quote.dart';
import 'package:Fintech/modals/stock.dart';
import 'package:Fintech/providers/stocks_provider.dart';
import 'package:Fintech/screens/stock_screen.dart';
import 'package:Fintech/services/finhub.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StocksList extends StatelessWidget {
  final Finhub finHub;
  StocksList(this.finHub);

  @override
  Widget build(BuildContext context) {
    final String exchange = Provider.of<StocksProvider>(context).exchange;
    final List stocksList = Provider.of<StocksProvider>(context)
        .stocks
        .where((stock) => stock.type == exchange)
        .toList();
    // context.watch<StocksProvider>().stocks;

    String getPercentageShift(snapshot, index) {
      Map<Stock, Quote> stockQuote = snapshot.data;
      Quote quote = stockQuote[stocksList.elementAt(index)];
      if (quote == null) {
        return "NA";
      }
      double openPrice = double.parse(quote.openPrice);
      double currentPrice = double.parse(quote.currentPrice);
      double percent = ((currentPrice / openPrice) - 1) * 100;
      return percent.toStringAsFixed(2);
    }

    return StreamBuilder(
        stream: finHub.fetchRealTimeExchangePrice(stocksList),
        builder: (context, snapshot) {
          return snapshot.connectionState != ConnectionState.waiting
              ? ListView.builder(
                  itemCount: stocksList.length,
                  itemBuilder: (context, index) => Card(
                      child: ListTile(
                    title: Text(stocksList.elementAt(index).description,
                        style: TextStyle(color: Theme.of(context).accentColor)),
                    subtitle:
                        getPercentageShift(snapshot, index).startsWith('-')
                            ? Text(
                                getPercentageShift(snapshot, index),
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                getPercentageShift(snapshot, index),
                                style: TextStyle(color: Colors.green),
                              ),
                    trailing:
                        (snapshot.data[stocksList.elementAt(index)]) == null
                            ? Text('loading')
                            : Text(
                                (snapshot.data[stocksList.elementAt(index)])
                                    .currentPrice,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                    leading: CircleAvatar(
                      child: Image.network(
                          "https://static.finnhub.io/logo/87cb30d8-80df-11ea-8951-00000000092a.png"),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StockScreen(
                                    stocksList.elementAt(index),
                                    snapshot.data[stocksList.elementAt(index)],
                                    finHub,
                                  )));
                    },
                  )),
                )
              : Center(child: CircularProgressIndicator(strokeWidth: 1));
        });
  }
}
