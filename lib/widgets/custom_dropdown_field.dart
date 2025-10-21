import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdownField extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final String hintText;
  final Function(String?) onChanged;

  const CustomDropdownField({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Debug print to see what value is being received
    print('CustomDropdownField building with value: "$selectedValue"');
    print('Is selected value null? ${selectedValue == null}');
    print('Is selected value empty? ${selectedValue?.isEmpty}');

    return DropdownButtonFormField<String>(
      // Explicitly setting value or null
      value:
          (selectedValue != null && selectedValue!.isNotEmpty)
              ? selectedValue
              : null,
      onChanged: onChanged,
      dropdownColor: Colors.black87,
      iconEnabledColor: Colors.white70,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
      ),
      // Show selected value or hint
      hint: Text(
        hintText,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14.sp,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
      ),
      // Ensure selected item is visible with proper styling
      selectedItemBuilder: (context) {
        return items.map<Widget>((String item) {
          return Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Add icon based on gender
                Icon(
                  item == 'Male' ? Icons.male : Icons.female,
                  color: item == 'Male' ? Colors.blue : Colors.pink,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                // Text with styling
                Text(
                  item,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
      items:
          items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                child: Row(
                  children: [
                    // Add icon based on gender
                    Icon(
                      value == 'Male' ? Icons.male : Icons.female,
                      color: value == 'Male' ? Colors.blue : Colors.pink,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    // Text with better styling
                    Text(
                      value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
