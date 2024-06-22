import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_models.dart';
import 'package:money_manager/screen/add_transaction/screen_add_transaction.dart';
import 'package:money_manager/screen/category/add_popup_category.dart';
import 'package:money_manager/screen/category/screen_category.dart';
import 'package:money_manager/screen/home/widgets/bottom_navigation.dart';
import 'package:money_manager/screen/transactions/screen_transaction.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});
  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  final _pages = const [
    ScreenTransaction(),
    ScreenCategory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Manager'),
        centerTitle: true,
      ),
      bottomNavigationBar: MoneyManagerBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: selectedIndexNotifier,
            builder: (BuildContext context, int updatedIndex, _) {
              return _pages[updatedIndex];
            }),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (selectedIndexNotifier.value == 0) {
              print('add transaction');
              Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
            } else {
              print('add category');

              showcategoryAddpopup(context);
              final _sample = CategoryModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: 'travel',
                  type: CategoryType.expense);
              CategoryDb().insertCategory(_sample);
            }
          },
          child: Icon(Icons.add)),
    );
  }
}
