import 'package:flutter/material.dart';

class PortfolioAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text(
        'Stocks',
        style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
      ),
      bottom: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.15),
        child: Card(
          child: TabBar(tabs: <Tab>[
            Tab(
                child: Text(
              'OPEN',
              style: TextStyle(color: Theme.of(context).primaryColor),
            )),
            Tab(
                child: Text(
              'CLOSED',
              style: TextStyle(color: Theme.of(context).primaryColor),
            )),
            Tab(
                child: Text(
              'ORDERS',
              style: TextStyle(color: Theme.of(context).primaryColor),
            )),
          ]),
        ),
      ),
    );
  }
}
