import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_models.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> showcategoryAddpopup(BuildContext context) async {
  final _nameEditingController = TextEditingController();
  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title: Text('add category'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameEditingController,
              decoration: InputDecoration(
                hintText: 'category name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                RadioButton(
                  title: 'income',
                  type: CategoryType.income,
                ),
                RadioButton(
                  title: 'expense',
                  type: CategoryType.expense,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                final _name = _nameEditingController.text;
                if (_name.isEmpty) {
                  return;
                }

                final _type = selectedCategoryNotifier.value;
                final _Category = CategoryModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: _name,
                    type: _type);
                CategoryDb.instance.insertCategory(_Category);
                Navigator.of(ctx).pop();
              },
              child: const Text('add'),
            ),
          )
        ],
      );
    },
  );
}

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;
  RadioButton({
    Key? key,
    required this.title,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategoryNotifier,
          builder: (BuildContext ctx, CategoryType newCategory, Widget? _) {
            return Radio<CategoryType>(
              value: type,
              groupValue: newCategory,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                selectedCategoryNotifier.value = value;
                selectedCategoryNotifier.notifyListeners();
              },
            );
          },
        ),
        Text(title)
      ],
    );
  }
}
