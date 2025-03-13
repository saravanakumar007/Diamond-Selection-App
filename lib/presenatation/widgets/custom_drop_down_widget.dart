import 'package:diamond_selection_app/data/models/app_data_model.dart';
import 'package:flutter/material.dart';

class CustomDropDownWidget extends StatefulWidget {
  const CustomDropDownWidget({
    super.key,
    required this.selectedData,
    required this.onSelect,
    this.isSortingType = false,
    this.filterType = FilterType.lab,
  });

  final String selectedData;

  final bool isSortingType;

  final FilterType filterType;

  final Function onSelect;

  @override
  State<CustomDropDownWidget> createState() => _CustomDropDownWidgetState();
}

class _CustomDropDownWidgetState extends State<CustomDropDownWidget> {
  List<String> dropdownList = [];

  String selectedData = 'None';

  @override
  void initState() {
    super.initState();
    selectedData = widget.selectedData;
    generateData();
  }

  void generateData() {
    dropdownList.add('None');
    if (!widget.isSortingType) {
      switch (widget.filterType) {
        case FilterType.lab:
          dropdownList.addAll(AppDataModel.filterData['Lab'].cast<String>());
          break;
        case FilterType.shape:
          dropdownList.addAll(AppDataModel.filterData['Shape'].cast<String>());
          break;
        case FilterType.color:
          dropdownList.addAll(AppDataModel.filterData['Color'].cast<String>());
          break;
        case FilterType.clarity:
          dropdownList.addAll(
            AppDataModel.filterData['Clarity'].cast<String>(),
          );
          break;
      }
    } else {
      dropdownList.addAll(['Ascending', 'Descending']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: selectedData,
      onChanged: (newValue) {
        widget.onSelect(newValue);
        setState(() {
          selectedData = newValue!;
        });
      },
      items:
          dropdownList.map((data) {
            return DropdownMenuItem(value: data, child: Text(data));
          }).toList(),
    );
  }
}
