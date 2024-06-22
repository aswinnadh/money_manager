import 'package:flutter/material.dart';

import 'package:money_manager/screen/category/expense_category_list.dart';
import 'package:money_manager/screen/category/income_category_list.dart';

import '../../db/category/category_db.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDb().refreshUi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(
                text: 'income',
              ),
              Tab(
                text: 'expense',
              )
            ]),
        Expanded(
          child: TabBarView(controller: _tabController, children: const [
            IncomeCategoryList(),
            ExpenseCategoryList(),
          ]),
        )
      ],
    );
  }
}
