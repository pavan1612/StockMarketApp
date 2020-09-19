import 'package:Fintech/models/quote.dart';
import 'package:Fintech/models/stock.dart';
import 'package:Fintech/services/chart_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewTransaction extends StatefulWidget {
  final Stock stock;
  final String type;

  final ChartData finHub;
  double value = 1;
  double amount = 1;
  NewTransaction(this.stock, this.finHub, this.type);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  TextEditingController amountController;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Quote quote = Provider.of<List<Quote>>(context)
        .firstWhere((element) => element.stockSymbol == widget.stock.symbol);

    void submitTx() {
      Map<String, String> transaction = {
        'userID': 'Pavan',
        'stockID': widget.stock.symbol,
        'amount': widget.amount.toStringAsFixed(5),
        'value': quote.currentPrice,
        'type': widget.type,
        'status': 'open',
      };
      firestore.collection('transactions').add(transaction);
      Navigator.of(context).pop();
    }

    return Container(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.type + ' ' + widget.stock.description,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type:' + widget.type),
            Text('Current Price:' + quote.currentPrice),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Amount:',
                    hintText: '1',
                  ),
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    setState(() {
                      widget.amount = double.parse(value);
                    });
                  }),
            ),
            Text(
              'value:' +
                  (double.parse(quote.currentPrice) * widget.amount)
                      .toStringAsFixed(2),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                    onPressed: () => submitTx(),
                    child: Text(
                      widget.type,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )),
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    )),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
