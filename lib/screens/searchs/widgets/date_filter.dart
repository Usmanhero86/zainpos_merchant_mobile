import 'package:flutter/material.dart';

class DateFilter extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback? onTap;
  final String? hintText;
  final String? labelText;
  final Color? borderColor;
  final Color? textColor;
  final Color? hintColor;

  const DateFilter({
    super.key,
    this.selectedDate,
     this.onTap,
    this.hintText,
    this.labelText,
    this.borderColor,
    this.textColor,
    this.hintColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText ?? 'Filter by Date',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor ?? Colors.grey.shade400,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null
                      ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                      : hintText ?? 'Select Date',
                  style: TextStyle(
                    color: selectedDate != null
                        ? textColor ?? Colors.black
                        : hintColor ?? Colors.grey,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}