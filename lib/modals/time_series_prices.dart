class TimeSeriesPrices {
  final DateTime time;
  final double price;

  TimeSeriesPrices(this.time, this.price);

  DateTime getTime() {
    return time;
  }

  double getPrice() {
    return price;
  }
}
