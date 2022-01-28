import 'package:flutter/material.dart';

class Transaction {
  final String id;
  final String item;
  final double amount;
  String category = "Undefined";
  final DateTime date;

  Transaction(
      {@required this.id,
      @required this.item,
      @required this.amount,
      this.category = "Undefined",
      @required this.date});
}
