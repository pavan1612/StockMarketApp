import 'package:Fintech/modals/quote.dart';
import 'package:Fintech/modals/stock.dart';
import 'package:Fintech/services/finhub.dart';
import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Stock stock;
  final String type;
  final Quote quote;
  final Finhub finHub;
  double value = 1;
  double amount = 1;
  NewTransaction(this.stock, this.quote, this.finHub, this.type);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  TextEditingController amountController;

  @override
  Widget build(BuildContext context) {
    void updatePrice(String currentPrice) {
      final double amount = double.parse(amountController.text);
    }

    void submitTx() {
      //

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
            StreamBuilder(
                stream: widget.finHub.fetchRealTimeStockPrice(widget.stock),
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? Text('Loading')
                        : Text('Current Price:' + snapshot.data.toString())),
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
            StreamBuilder(
              stream: widget.finHub.fetchRealTimeStockPrice(widget.stock),
              builder: (context, snapshot) => snapshot.connectionState ==
                      ConnectionState.waiting
                  ? Text('Loading')
                  : Text('value:' +
                      (double.parse(snapshot.data.toString()) * widget.amount)
                          .toStringAsFixed(2)),
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
