import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import '../../models/transactions/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transaction_db';

abstract class TransactionFunctions {
  Future<void> addTransaction(TransactionModel obj);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> deleteTransaction(String id);
}

class TransactionDb implements TransactionFunctions {
  TransactionDb._internal();
  static TransactionDb instance = TransactionDb._internal();
  factory TransactionDb() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.put(obj.id, obj);
  }

  Future<void> refresh() async {
    final _list = await getAllTransactions();
    _list.sort((first, second) => second.date.compareTo(first.date));
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_list);
    transactionListNotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return _db.values.toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.delete(id);
    refresh();
  }
}
