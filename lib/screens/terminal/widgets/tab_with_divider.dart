import'package:flutter/material.dart';

Tab buildTabWithDivider(String text, {bool showRightDivider = false}) {
  return Tab(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text),
        if (showRightDivider) ...[
          SizedBox(width: 8),
          Container(
            width: 1,
            height: 45,
            color: Colors.black26,
          ),
          const SizedBox(width: 8),
        ],
      ],
    ),
  );
}
