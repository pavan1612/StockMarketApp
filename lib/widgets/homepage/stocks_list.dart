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
    final List stocksList = (exchange == 'all')
        ? Provider.of<StocksProvider>(context).stocks
        : Provider.of<StocksProvider>(context)
            .stocks
            .where((stock) => stock.type == exchange)
            .toList();
    List<Quote> quotesList = Provider.of<List<Quote>>(context);
    // print('reloaded again');
    return ListView.builder(
      itemCount: stocksList.length,
      itemBuilder: (context, index) {
        Stock stock = stocksList.elementAt(index);

        Quote quote = quotesList
            .firstWhere((element) => element.stockSymbol == stock.symbol);
        String percentShift = quote.variedPercentage;
        return Card(
            child: ListTile(
          title: Text(stocksList.elementAt(index).description,
              style: TextStyle(color: Theme.of(context).accentColor)),
          subtitle: percentShift.startsWith('-')
              ? Text(
                  percentShift,
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                )
              : Text(
                  percentShift,
                  style: TextStyle(color: Colors.green),
                ),
          trailing: Text(
            quote.currentPrice,
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
                          stock,
                          finHub,
                        )));
          },
        ));
      },
    );
  }
}
