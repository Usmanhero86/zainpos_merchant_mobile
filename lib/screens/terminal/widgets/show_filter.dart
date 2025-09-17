import 'package:flutter/material.dart';
import '../../searchs/search_and_filter.dart';

void showSearchFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) =>  SearchAndFilterScreen(),
  );
}
