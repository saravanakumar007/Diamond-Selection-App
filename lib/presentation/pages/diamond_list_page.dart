import 'dart:math';

import 'package:diamond_selection_app/business_logic/cart_list/cart_list_cubit.dart';
import 'package:diamond_selection_app/business_logic/diamond_list/diamond_list_cubit.dart';
import 'package:diamond_selection_app/business_logic/diamond_list/dimond_list_state.dart';
import 'package:diamond_selection_app/data.dart';
import 'package:diamond_selection_app/data/models/app_data_model.dart';
import 'package:diamond_selection_app/data/repositories/cart_item_repository.dart';
import 'package:diamond_selection_app/presentation/pages/cart_page.dart';
import 'package:diamond_selection_app/presentation/pages/filter_page.dart';
import 'package:diamond_selection_app/presentation/widgets/diamond_card_widget.dart';
import 'package:diamond_selection_app/presentation/widgets/custom_drop_down_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiamondListPage extends StatefulWidget {
  const DiamondListPage({super.key});

  @override
  State<DiamondListPage> createState() => _DiamondListPageState();
}

class _DiamondListPageState extends State<DiamondListPage> {
  @override
  void initState() {
    super.initState();
    fetchData();
    generateFilterData();
  }

  void fetchData() {
    BlocProvider.of<DiamondListCubit>(context).fetchDiamondData();
  }

  void fetchFilterAndSortingData() {
    BlocProvider.of<DiamondListCubit>(context).applyFilterAndSortingData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiamondListCubit, DiamondListState>(
      builder:
          (context, state) => Scaffold(
            floatingActionButton: Builder(
              builder: (context) {
                if (state is DiamondSucessState && state.hasCartItems) {
                  return IntrinsicWidth(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder:
                                    (context) => BlocProvider(
                                      create:
                                          (context) => CartListCubit(
                                            CartItemRepository(),
                                          ),
                                      child: CartPage(),
                                    ),
                              ),
                            )
                            .then((_) {
                              fetchData();
                            });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.orange,
                        ),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'View Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
            backgroundColor: Colors.white,

            appBar: AppBar(
              centerTitle: false,
              backgroundColor: Colors.green,
              title: Text(
                'Diamond List',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: SizedBox(),
              actions: [
                InkWell(
                  onTap: () async {
                    showFilterModelBottomSheet();
                  },
                  child: Container(
                    height: 30,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 2),
                          spreadRadius: 0,
                          blurRadius: 2,
                          color: Colors.grey,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(Icons.filter_alt_outlined),
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    showSortModelBottomSheet();
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    height: 30,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 2),
                          spreadRadius: 0,
                          blurRadius: 1,
                          color: Colors.grey,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(Icons.sort),
                  ),
                ),
              ],
            ),
            body: Builder(
              builder: (context) {
                if (state is DiamondInitialState ||
                    state is DiamondLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  );
                } else if (state is DiamondSucessState) {
                  return state.data.isNotEmpty
                      ? ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(20),
                        itemBuilder:
                            (context, index) => DiamondCardWidget(
                              data: state.data[index],
                              index: index,
                            ),
                        separatorBuilder:
                            (context, index) => SizedBox(height: 20),
                        itemCount: state.data.length,
                      )
                      : Center(
                        child: Text(
                          'No Data Found',
                          style: TextStyle(color: Colors.green, fontSize: 30),
                        ),
                      );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
    );
  }

  void showFilterModelBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterPage(),
    ).then((_) {
      fetchFilterAndSortingData();
    });
  }

  void showSortModelBottomSheet() {
    String finalPriceOrderType = AppDataModel.finalPriceOrderType;
    String caratWeightOrderType = AppDataModel.caratWeightOrderType;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => Container(
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
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Final Price (Asc/Desc)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    CustomDropDownWidget(
                      selectedData: AppDataModel.finalPriceOrderType,
                      onSelect: (value) {
                        finalPriceOrderType = value;
                      },
                      isSortingType: true,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Carat Weight (Asc/Desc)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    CustomDropDownWidget(
                      selectedData: AppDataModel.caratWeightOrderType,
                      onSelect: (value) {
                        caratWeightOrderType = value;
                      },
                      isSortingType: true,
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        AppDataModel.finalPriceOrderType = finalPriceOrderType;
                        AppDataModel.caratWeightOrderType =
                            caratWeightOrderType;

                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    ).then((_) {
      fetchFilterAndSortingData();
    });
  }

  void generateFilterData() {
    final List<String> labData = [];
    final List<String> shapeData = [];
    final List<String> colorData = [];
    final List<String> clarityData = [];
    double? caratMin, caratMax;
    for (int i = 0; i < diamondsData.length; i++) {
      final dynamic data = diamondsData[i];
      final String lab = (data['Lab'] ?? '').toString().trim();
      final String shape = (data['Shape'] ?? '').toString().trim();
      final String color = (data['Color'] ?? '').toString().trim();
      final String clarity = (data['Clarity'] ?? '').toString().trim();
      if (data['Carat'] != null) {
        caratMin = min(
          data['Carat'].toDouble(),
          (caratMin ?? data['Carat'].toDouble()),
        );
        caratMax = max(
          data['Carat'].toDouble(),
          (caratMax ?? data['Carat'].toDouble()),
        );
      }
      if (lab.isNotEmpty && !labData.contains(lab)) {
        labData.add(lab);
        AppDataModel.filterData.putIfAbsent('Lab', () => []).add(lab);
      }
      if (shape.isNotEmpty && !shapeData.contains(shape)) {
        shapeData.add(shape);
        AppDataModel.filterData.putIfAbsent('Shape', () => []).add(shape);
      }
      if (color.isNotEmpty && !colorData.contains(color)) {
        colorData.add(color);
        AppDataModel.filterData.putIfAbsent('Color', () => []).add(color);
      }
      if (clarity.isNotEmpty && !clarityData.contains(clarity)) {
        clarityData.add(clarity);
        AppDataModel.filterData.putIfAbsent('Clarity', () => []).add(clarity);
      }
    }
    AppDataModel.filterData['caratMin'] = caratMin;
    AppDataModel.filterData['caratMax'] = caratMax;
    AppDataModel.caratMin = caratMin;
    AppDataModel.caratMax = caratMax;
  }
}
