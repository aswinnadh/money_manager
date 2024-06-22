import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transactions/transaction_db.dart';
import 'package:money_manager/models/category/category_models.dart';

import '../../models/transactions/transaction_model.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDb.instance.refresh();
    CategoryDb.instance.refreshUi();
    return ValueListenableBuilder(
      valueListenable: TransactionDb.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
        return ListView.separated(
          padding: EdgeInsets.all(10),
          itemBuilder: (ctx, index) {
            final _value = newList[index];

            return Slidable(
              key: Key(_value.id!),
              startActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (ctx) {
                      TransactionDb.instance.deleteTransaction(_value.id!);
                    },
                    icon: Icons.delete,
                    label: 'delete',
                  ),
                ],
              ),
              child: Card(
                elevation: 0,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 50,
                    child: Text(
                      parseDate(_value.date),
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: _value.type == CategoryType.income
                        ? Colors.green
                        : Colors.red,
                  ),
                  title: Text('Rs ${_value.amount}'),
                  subtitle: Text(_value.category.name),
                ),
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemCount: newList.length,
        );
      },
    );
  }

  String parseDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitedDate = _date.split('');
    // return DateFormat.MMMd().format(date);
    return '${_splitedDate.last}\n${_splitedDate.first}';
  }
}
