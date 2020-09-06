import 'package:Fintech/modals/quote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Portfolio extends StatelessWidget {
  calculateProfitLoss(QueryDocumentSnapshot userstock, List<Quote> quotesList) {
    double amount = double.parse(userstock.get('amount'));
    double value = double.parse(userstock.get('value'));
    Quote qoute = quotesList.firstWhere(
        (element) => element.stockSymbol == userstock.get('stockID'));
    double currentValue = double.parse(qoute.currentPrice);
    double profitLoss = (amount * value) - (amount * currentValue);
    return profitLoss.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final List<QueryDocumentSnapshot> userStocks =
        Provider.of<QuerySnapshot>(context).docs;
    List<Quote> quotesList = Provider.of<List<Quote>>(context);
    return TabBarView(children: [
      Container(
        child: ListView.builder(
            itemCount: userStocks.length,
            itemBuilder: (context, index) => ListTile(
                  title: Text(userStocks.elementAt(index).get('stockID')),
                  trailing: FlatButton(onPressed: null, child: Text('Close')),
                  subtitle: Text(
                    calculateProfitLoss(
                        userStocks.elementAt(index), quotesList),
                  ),
                )),
      ),
      Container(
        child: ListView.builder(
            itemCount: userStocks.length,
            itemBuilder: (context, index) => ListTile(
                  title: Text(userStocks.elementAt(index).get('stockID')),
                  trailing: FlatButton(onPressed: null, child: Text('Close')),
                  subtitle: Text(
                    calculateProfitLoss(
                        userStocks.elementAt(index), quotesList),
                  ),
                )),
      ),
      Container(
        child: ListView.builder(
            itemCount: userStocks.length,
            itemBuilder: (context, index) => ListTile(
                  title: Text(userStocks.elementAt(index).get('stockID')),
                  trailing: FlatButton(onPressed: null, child: Text('Close')),
                  subtitle: Text(
                    calculateProfitLoss(
                        userStocks.elementAt(index), quotesList),
                  ),
                )),
      ),
    ]);
  }
}
