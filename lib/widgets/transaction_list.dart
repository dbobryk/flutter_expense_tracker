// ignore_for_file: use_key_in_widget_constructors

import 'package:expense_tracker/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTransaction;

  const TransactionList(this.userTransactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return userTransactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: [
                  Text(
                    'Add a transaction.',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: constraints.maxHeight * .05,
                  ),
                  SizedBox(
                    height: constraints.maxHeight * .6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView(
            children: userTransactions
                .map(
                  (e) => TransactionItem(
                      key: ValueKey(e.id),
                      transaction: e,
                      deleteTransaction: deleteTransaction),
                )
                .toList(),
          );
  }
}
