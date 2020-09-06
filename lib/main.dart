import 'package:Fintech/providers/stocks_provider.dart';
import 'package:Fintech/screens/stock_screen.dart';
import 'package:Fintech/widgets/homepage/stocks_list.dart';
import 'package:flutter/material.dart';
import "package:Fintech/screens/homepage.dart";
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StocksProvider()),
        StreamProvider(
            create: (context) =>
                Provider.of<StocksProvider>(context).stockPrices)
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}
