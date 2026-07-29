import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/category.dart';

class CategoryTile extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;

  const CategoryTile({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap ??
          () => context.push('/categories/${category.slug}', extra: category),
      title: Text(category.title,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: category.description.isNotEmpty
          ? Text(
              category.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          '${category.totalMediaCount}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
