import 'package:expense_tracker/widgets/chart.dart';
import 'package:expense_tracker/widgets/new_transaction.dart';
import 'package:expense_tracker/widgets/transaction_list.dart';
import 'package:flutter/material.dart';

import 'models/transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        primaryColor: Colors.lightBlue,
        fontFamily: "QuickSand",
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];
  bool _chartShown = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    AppBar appBar = AppBar(
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

    final _txListWidget = SizedBox(
      height: mediaQuery.size.height * .6,
      child: TransactionList(
        _userTransactions,
        _deleteTransaction,
      ),
    );

    return Scaffold(
        appBar: appBar,
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Show Chart'),
                    Switch(
                      value: _chartShown,
                      onChanged: (val) {
                        setState(() {
                          _chartShown = val;
                        });
                      },
                    ),
                  ],
                ),
              if (!isLandscape)
                SizedBox(
                  height: mediaQuery.size.height * .3,
                  child: Chart(_recentTransactions),
                ),
              if (!isLandscape) _txListWidget,
              if (isLandscape)
                _chartShown
                    ? SizedBox(
                        height: mediaQuery.size.height * .7,
                        child: Chart(_recentTransactions),
                      )
                    : _txListWidget
            ],
          ),
        ));
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
