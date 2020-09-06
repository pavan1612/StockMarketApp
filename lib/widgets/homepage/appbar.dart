import 'package:Fintech/providers/stocks_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageAppBar extends StatelessWidget {
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
            Size.fromHeight(MediaQuery.of(context).size.height * 0.22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              child: DropdownButton(
                value: context.watch<StocksProvider>().exchange,
                icon: Icon(Icons.keyboard_arrow_down,
                    color: Theme.of(context).primaryColor),
                items: [
                  DropdownMenuItem(
                      child: Container(
                        child: Text(
                          'Crypto',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      value: 'crypto'),
                  DropdownMenuItem(
                      child: Container(
                        child: Text(
                          'US Stocks',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      value: 'US'),
                  DropdownMenuItem(
                      child: Container(
                        child: Text(
                          'Forex',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      value: 'forex'),
                  DropdownMenuItem(
                      child: Container(
                        child: Text(
                          'All',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      value: 'all'),
                ],
                onChanged: (itemIdentifier) {
                  switch (itemIdentifier) {
                    case 'crypto':
                      Provider.of<StocksProvider>(context)
                          .setExchange('crypto');

                      break;
                    case 'US':
                      Provider.of<StocksProvider>(context).setExchange('US');

                      break;
                    case 'forex':
                      Provider.of<StocksProvider>(context).setExchange('forex');

                      break;
                    case 'all':
                      Provider.of<StocksProvider>(context).setExchange('all');

                      break;
                    default:
                  }
                },
              ),
            ),
            Container(
                padding:
                    EdgeInsets.only(bottom: 5, right: 20, left: 20, top: 5),
                child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) =>
                        context.read<StocksProvider>().searchStocks(value),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: '    Search',
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ))),
          ],
        ),
      ),
    );
  }
}
