class UserStock {
  final String userID;
  final String stockID;
  final String amount;
  final String value;
  final String type;
  final String status;

  UserStock(this.userID, this.stockID, this.amount, this.value, this.type,
      this.status);
}

// 'userID': 'Pavan',
//         'stockID': widget.stock.symbol,
//         'amount': widget.amount.toStringAsFixed(5),
//         'value': quote.currentPrice,
//         'type': widget.type,
//         'status': 'open',
