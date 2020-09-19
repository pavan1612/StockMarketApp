import 'package:Fintech/screens/portfolio_screen.dart';
import 'package:Fintech/widgets/homepage/appbar.dart';
import 'package:Fintech/widgets/homepage/stocks_list.dart';
import 'package:Fintech/widgets/portfolio_screen/appbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      StocksList(),
      Portfolio(),
      Center(child: Text('To do...')),
    ];
    List<Widget> _appbarOptions = <Widget>[
      PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.22),
          child: HomePageAppBar()),
      PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.18),
          child: PortfolioAppbar()),
      PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.15),
          child: AppBar()),
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: _appbarOptions.elementAt(selectedIndex),
          body: _widgetOptions.elementAt(selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.trending_up), title: Text('Stocks')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet),
                  title: Text('Portfolio')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle), title: Text('Account')),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: Theme.of(context).primaryColor,
            onTap: (index) {
              this.setState(() {
                selectedIndex = index;
                print(selectedIndex);
              });
            },
          )),
    );
  }
}
