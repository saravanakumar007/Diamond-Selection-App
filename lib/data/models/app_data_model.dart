enum FilterType { lab, shape, color, clarity }

class AppDataModel {
  static List<dynamic> diamondData = [];
  static final Map<String, dynamic> filterData = {};
  static double? caratMin;
  static double? caratMax;
  static String labSelectedType = 'None';
  static String shapeSelectedType = 'None';
  static String colorSelectedType = 'None';
  static String claritySelectedType = 'None';
  static String finalPriceOrderType = 'None';
  static String caratWeightOrderType = 'None';
}
