import 'package:amonoroze_panel_admin/app_config/app_style/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> list;
  T? selected;
  final Function(T?)? onChanged;
  final String title;

  CustomDropdown({
    required this.list,
    this.selected,
    this.onChanged,
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsetsDirectional.symmetric(vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton<T>(
            value: widget.list.contains(widget.selected) ? widget.selected : null,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 16,
            style: const TextStyle(color: Colors.black, fontSize: 16),
            onChanged: (T? newValue) {
              setState(() {
                widget.selected = newValue;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(newValue);
              }
            },
            items: widget.list.isNotEmpty
                ? widget.list.map<DropdownMenuItem<T>>((T value) {
                    return DropdownMenuItem<T>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList()
                : null,
          ),
          SizedBox(width: 5.w),
          Text(widget.title, style: AppFonts.labelMedium),
        ],
      ),
    );
  }
}
