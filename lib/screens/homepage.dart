import 'package:Fintech/widgets/homepage/appbar.dart';
import 'package:Fintech/widgets/homepage/stocks_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      StocksList(),
      Text('Shit'),
      StocksList(),
    ];
    int selectedIndex = 0;

    return Scaffold(
        appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.22),
            child: HomePageAppBar()),
        body: _widgetOptions.elementAt(selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet),
                title: Text('Stocks')),
            BottomNavigationBarItem(
                icon: Icon(Icons.ac_unit), title: Text('Portfolio')),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), title: Text('Account')),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
              print('object');
            });
          },
        ));
  }
}
