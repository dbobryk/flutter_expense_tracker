import 'dart:io';

import 'package:expense_tracker/widgets/chart.dart';
import 'package:expense_tracker/widgets/new_transaction.dart';
import 'package:expense_tracker/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/transaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? const CupertinoApp(
            title: 'Expense Tracker',
            theme: CupertinoThemeData(
              primaryColor: Colors.lightBlue,
              primaryContrastingColor: Colors.grey,
              // fontFamily: "QuickSand",
            ),
            home: MyHomePage(),
          )
        : MaterialApp(
            title: 'Expense Tracker',
            theme: ThemeData(
              primarySwatch: Colors.lightBlue,
              primaryColor: Colors.lightBlue,
              fontFamily: "QuickSand",
            ),
            home: const MyHomePage(),
          );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];
  bool _chartShown = false;

  List<Widget> _buildLandScapeContent(
    MediaQueryData mediaQueryData,
    Widget txListWidget,
    List<Transaction> recentTransactions,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Show Chart'),
          Switch.adaptive(
            activeColor: Theme.of(context).primaryColorLight,
            value: _chartShown,
            onChanged: (val) {
              setState(() {
                _chartShown = val;
              });
            },
          ),
        ],
      ),
      _chartShown
          ? SizedBox(
              height: mediaQueryData.size.height * .7,
              child: Chart(recentTransactions),
            )
          : txListWidget,
    ];
  }

  List<Widget> _buildPortraitContent(
    MediaQueryData mediaQueryData,
    Widget txListWidet,
  ) {
    return [
      SizedBox(
        height: mediaQueryData.size.height * .3,
        child: Chart(_recentTransactions),
      ),
      txListWidet,
    ];
  }

  Widget _buildCupertinoNavigationBar() {
    return CupertinoNavigationBar(
      middle: const Text("Expense Tracker"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _startAddNewTransaction(context),
            child: const Icon(CupertinoIcons.add),
          )
        ],
      ),
    );
  }

  Widget _buildMaterialAppBar() {
    return AppBar(
      title: const Text('Expense Tracker',
          style: TextStyle(
            fontFamily: "OpenSans",
          )),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    PreferredSizeWidget appBar = Platform.isIOS
        ? _buildCupertinoNavigationBar()
        : _buildMaterialAppBar();

    final _txListWidget = SizedBox(
      height: mediaQuery.size.height * .57,
      child: TransactionList(
        _userTransactions,
        _deleteTransaction,
      ),
    );

    final body = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (isLandscape)
              ..._buildLandScapeContent(
                  mediaQuery, _txListWidget, _recentTransactions),
            if (!isLandscape)
              ..._buildPortraitContent(mediaQuery, _txListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: body,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
            body: body,
          );
  }

  void _addNewTransaction(String item, double amount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      item: item,
      amount: amount,
      date: chosenDate,
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (bCtx) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where(
      (e) {
        return e.date.isAfter(
          DateTime.now().subtract(
            const Duration(days: 7),
          ),
        );
      },
    ).toList();
  }
}
