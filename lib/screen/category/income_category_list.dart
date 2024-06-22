import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../db/category/category_db.dart';
import '../../models/category/category_models.dart';

class IncomeCategoryList extends StatelessWidget {
  const IncomeCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: CategoryDb().incomeCategoryListListener,
        builder: (BuildContext ctx, List<CategoryModel> newlist, Widget? _) {
          return ListView.separated(
            itemBuilder: (ctx, index) {
              final category = newlist[index];
              return Card(
                child: ListTile(
                  title: Text(category.name),
                  trailing: IconButton(
                      onPressed: () {
                        CategoryDb.instance.deleteCategory(category.id);
                      },
                      icon: const Icon(Icons.delete)),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return SizedBox(
                height: 10,
              );
            },
            itemCount: newlist.length,
          );
        });
  }
}
