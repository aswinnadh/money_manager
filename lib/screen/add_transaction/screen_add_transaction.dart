import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transactions/transaction_db.dart';
import '../../models/category/category_models.dart';
import '../../models/transactions/transaction_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = 'add transactons';
  const ScreenAddTransaction({super.key});

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;

  String? _categoryId;

  final _purposeTextEditindcontroller = TextEditingController();
  final _amountTextEditindcontroller = TextEditingController();

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // purpose
            TextField(
              controller: _purposeTextEditindcontroller,
              decoration: const InputDecoration(hintText: 'purpose'),
            ),
            TextField(
              controller: _amountTextEditindcontroller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'amount'),
            ),

            TextButton.icon(
              onPressed: () async {
                final _selectDateTemp = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now(),
                );
                if (_selectDateTemp == null) {
                  return;
                } else {
                  print(_selectDateTemp.toString());
                  setState(() {
                    _selectedDate = _selectDateTemp;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(_selectedDate == null
                  ? 'select date'
                  : _selectedDate!.toString()),
            ),

            Row(
              // radio
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio(
                      value: CategoryType.income,
                      groupValue: _selectedCategoryType,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategoryType = CategoryType.income;
                          _categoryId = null;
                        });
                      },
                    ),
                    Text('income'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                      value: CategoryType.expense,
                      groupValue: _selectedCategoryType,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategoryType = CategoryType.expense;
                          _categoryId = null;
                        });
                      },
                    ),
                    Text('expense'),
                  ],
                ),
              ],
            ),
            // categoryType
            DropdownButton<String>(
              hint: const Text('select Category'),
              value: _categoryId,
              items: (_selectedCategoryType == CategoryType.income
                      ? CategoryDb().incomeCategoryListListener
                      : CategoryDb().expenseCategoryListListener)
                  .value
                  .map((e) {
                return DropdownMenuItem(
                  value: e.id,
                  child: Text(e.name),
                  onTap: () {
                    _selectedCategoryModel = e;
                  },
                );
              }).toList(),
              onChanged: (selectedValue) {
                print(selectedValue);
                setState(() {
                  _categoryId = selectedValue;
                });
              },
              onTap: () {},
            ),
            // submit
            ElevatedButton(
              onPressed: () {
                addTransactions();
              },
              child: Text('submit'),
            )
          ],
        ),
      )),
    );
  }

  Future<void> addTransactions() async {
    final _purposeText = _purposeTextEditindcontroller.text;
    final _amountText = _amountTextEditindcontroller.text;
    if (_purposeText.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }
    if (_categoryId == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    if (_selectedCategoryModel == null) {
      return;
    }
    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }
    // _selectDate;
    // _selectedCategoryType;
    // categoryId;
    final _model = TransactionModel(
      purpose: _purposeText,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
    );
    await TransactionDb.instance.addTransaction(_model);
    Navigator.of(context).pop();
  }
}
