class Quote {
  final String stockSymbol;
  String openPrice;
  String highPrice;
  String lowPrice;
  String currentPrice;
  String previousClosePrice;
  String variedPercentage = '0';

  Quote(
    this.stockSymbol,
    this.openPrice,
    this.highPrice,
    this.lowPrice,
    this.currentPrice,
    this.previousClosePrice,
  ) {
    double currentPrice = double.parse(this.currentPrice.toString());
    double openPrice = double.parse(this.openPrice);
    double percent = ((currentPrice / openPrice) - 1) * 100;
    variedPercentage = percent.toStringAsFixed(2);
  }

  setCurrentPrice(price) {
    this.currentPrice = price;
    double currentPrice = double.parse(price.toString());
    double openPrice = double.parse(this.openPrice);
    double percent = ((currentPrice / openPrice) - 1) * 100;
    variedPercentage = percent.toStringAsFixed(2);
  }
}
