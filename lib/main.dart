import 'package:Fintech/providers/quotes_provider.dart';
import 'package:Fintech/providers/stocks_provider.dart';
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
    final QuotesProvider _qp = new QuotesProvider();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StocksProvider()),
        StreamProvider(create: (BuildContext context) => _qp.update),
      ],
      builder: (context, child) => MaterialApp(
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
