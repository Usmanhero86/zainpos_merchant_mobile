import 'package:flutter/material.dart';
import '../../searchs/search_and_filter.dart';

void showSearchFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return FractionallySizedBox(
        heightFactor: 1.8 / 3,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const SearchAndFilterScreen(),
        ),
      );
    },
  );
}
