import 'package:Fintech/modals/stock.dart';
import 'package:Fintech/providers/stocks_provider.dart';
import 'package:Fintech/services/finhub.dart';
import 'package:Fintech/widgets/homepage/appbar.dart';
import 'package:Fintech/widgets/homepage/stocks_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Stock> stocksList;
  // String initialExchange = "crypto";
  final finHub = Finhub();

  @override
  void initState() {
    super.initState();
    // stocksList = finHub.fetchStocks(initialExchange);
  }

  @override
  Widget build(BuildContext context) {
    // void changeExchange(String exchange) {
    //   setState(() {
    //     // initialExchange = exchange;
    //     // stocksList = finHub.fetchStocks(initialExchange);
    //     context.read<StocksProvider>().fetchStocks(exchange);
    //   });
    // }

    // void search(String value) {
    //   setState(() {
    //     // stocksList = finHub.searchStocks(value);
    //     context.read<StocksProvider>().searchStocks(value);
    //   });
    // }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.22),
          child: HomePageAppBar()),
      body: StocksList(finHub),
    );
  }
}
