import 'package:Fintech/modals/quote.dart';
import 'package:Fintech/modals/stock.dart';
import 'package:Fintech/services/chart_data.dart';
import 'package:Fintech/widgets/stockspage/new_transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockPageAppBar extends StatelessWidget {
  final Stock stock;
  final ChartData finHub;

  StockPageAppBar(this.stock, this.finHub);

  void _startAddNewTransaction(BuildContext context, String type) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewTransaction(stock, finHub, type)));
  }

  @override
  Widget build(BuildContext context) {
    Quote quote = Provider.of<List<Quote>>(context)
        .firstWhere((element) => element.stockSymbol == stock.symbol);

    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        stock.description,
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 24),
      ),
      centerTitle: true,
      bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: GestureDetector(
                      onTap: () => _startAddNewTransaction(context, 'Buy'),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.green)),
                        child: Column(
                          children: [
                            Text(
                              'BUY',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(quote.currentPrice)
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Divider(color: Theme.of(context).primaryColor),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: GestureDetector(
                      onTap: () => _startAddNewTransaction(context, 'Sell'),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.red)),
                        child: Column(
                          children: [
                            Text('SELL',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(quote.currentPrice)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Theme.of(context).primaryColor,
                thickness: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Container(
                        margin: EdgeInsets.all(10), child: Text(stock.symbol)),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Container(
                          margin: EdgeInsets.all(10),
                          child: quote.variedPercentage.contains('-')
                              ? Text(
                                  quote.variedPercentage,
                                  style: TextStyle(color: Colors.red),
                                )
                              : Text(
                                  quote.variedPercentage,
                                  style: TextStyle(color: Colors.green),
                                )))
                ],
              )
            ],
          )),
    );
  }
}
