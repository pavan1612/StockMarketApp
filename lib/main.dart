import 'package:Fintech/providers/quotes_provider.dart';
import 'package:Fintech/providers/stocks_provider.dart';
import 'package:Fintech/providers/user_stocks_provider.dart';
import 'package:flutter/material.dart';
import "package:Fintech/screens/homepage.dart";
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp(name: 'Fintech');
    final QuotesProvider _qp = new QuotesProvider();
    final UserStocksProvider _usp = new UserStocksProvider('Pavan');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StocksProvider()),
        StreamProvider(create: (BuildContext context) => _qp.update),
        StreamProvider(create: (context) => _usp.transactions),
        // StreamProvider(create: (context)=> _usp.userBalance),
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
