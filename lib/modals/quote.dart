class Quote {
  final String stockSymbol;
  final String openPrice;
  final String highPrice;
  final String lowPrice;
  String currentPrice;
  final String previousClosePrice;

  Quote(
    this.stockSymbol,
    this.openPrice,
    this.highPrice,
    this.lowPrice,
    this.currentPrice,
    this.previousClosePrice,
  );
}
