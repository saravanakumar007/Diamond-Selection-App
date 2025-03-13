import 'package:diamond_selection_app/data/models/app_data_model.dart';
import 'package:diamond_selection_app/presenatation/widgets/custom_drop_down_widget.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String labSelectedType = 'None';
  String shapeSelectedType = 'None';
  String colorSelectedType = 'None';
  String claritySelectedType = 'None';
  RangeValues rangeValues = RangeValues(
    AppDataModel.caratMin!,
    AppDataModel.caratMax!,
  );

  @override
  void initState() {
    super.initState();
    labSelectedType = AppDataModel.labSelectedType;
    shapeSelectedType = AppDataModel.shapeSelectedType;
    colorSelectedType = AppDataModel.colorSelectedType;
    claritySelectedType = AppDataModel.claritySelectedType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),

        color: Colors.white,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              Text(
                AppDataModel.filterData['caratMin'].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 20,
                ),
              ),
              SliderTheme(
                data: SliderThemeData(
                  trackShape: RoundedRectSliderTrackShape(),
                  showValueIndicator: ShowValueIndicator.always,
                  valueIndicatorTextStyle: TextStyle(color: Colors.green),
                  rangeThumbShape: RoundRangeSliderThumbShape(),
                ),
                child: RangeSlider(
                  labels: RangeLabels(
                    rangeValues.start.toStringAsFixed(1),
                    rangeValues.end.toStringAsFixed(1),
                  ),
                  min: AppDataModel.filterData['caratMin'],
                  max: AppDataModel.filterData['caratMax'],
                  activeColor: Colors.green,
                  inactiveColor: Colors.green.shade100,
                  values: rangeValues,
                  onChanged: (newRangeValues) {
                    setState(() {
                      rangeValues = newRangeValues;
                    });
                  },
                ),
              ),
              Text(
                AppDataModel.filterData['caratMax'].toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Lab',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 20,
                ),
              ),
              SizedBox(width: 30),
              CustomDropDownWidget(
                selectedData: AppDataModel.labSelectedType,
                onSelect: (value) {
                  labSelectedType = value;
                },
                filterType: FilterType.lab,
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Shape',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 20,
                ),
              ),
              SizedBox(width: 30),
              CustomDropDownWidget(
                selectedData: AppDataModel.shapeSelectedType,
                onSelect: (value) {
                  shapeSelectedType = value;
                },
                filterType: FilterType.shape,
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Color',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 20,
                ),
              ),
              SizedBox(width: 30),
              CustomDropDownWidget(
                selectedData: AppDataModel.colorSelectedType,
                onSelect: (value) {
                  colorSelectedType = value;
                },
                filterType: FilterType.color,
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Clarity',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 20,
                ),
              ),
              SizedBox(width: 30),
              CustomDropDownWidget(
                selectedData: AppDataModel.claritySelectedType,
                onSelect: (value) {
                  claritySelectedType = value;
                },
                filterType: FilterType.clarity,
              ),
            ],
          ),
          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  AppDataModel.caratMin = rangeValues.start;
                  AppDataModel.caratMax = rangeValues.end;
                  AppDataModel.labSelectedType = labSelectedType;
                  AppDataModel.shapeSelectedType = shapeSelectedType;
                  AppDataModel.colorSelectedType = colorSelectedType;
                  AppDataModel.claritySelectedType = claritySelectedType;
                  Navigator.of(context).pop();
                },
                child: Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
