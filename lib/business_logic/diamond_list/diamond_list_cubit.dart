import 'package:diamond_selection_app/business_logic/diamond_list/dimond_list_state.dart';
import 'package:diamond_selection_app/data.dart';
import 'package:diamond_selection_app/data/models/app_data_model.dart';
import 'package:diamond_selection_app/data/repositories/cart_item_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiamondListCubit extends Cubit<DiamondListState> {
  DiamondListCubit(this.cartItemRepository) : super(DiamondInitialState());

  final CartItemRepository cartItemRepository;

  Future<void> fetchDiamondData() async {
    emit(DiamondLoadingState());
    AppDataModel.diamondData = diamondsData;
    final List<String> cartItems =
        await cartItemRepository.getCartDataFromCache();
    bool hasAnyAddedIntoCartItems = false;
    for (int i = 0; i < AppDataModel.diamondData.length; i++) {
      AppDataModel.diamondData[i]['cartAdded'] = cartItems.contains(
        AppDataModel.diamondData[i]['Lot ID'],
      );
      if (AppDataModel.diamondData[i]['cartAdded']) {
        hasAnyAddedIntoCartItems = true;
      }
    }
    emit(
      DiamondSucessState(
        data: diamondsData,
        hasCartItems: hasAnyAddedIntoCartItems,
      ),
    );
  }

  Future<void> addItemIntoCart(dynamic data) async {
    emit(DiamondLoadingState());
    await cartItemRepository.addCartDataIntoCache(data);
    fetchDiamondData();
  }

  Future<void> applyFilterAndSortingData() async {
    List<dynamic> filterData = [];
    for (int i = 0; i < diamondsData.length; i++) {
      final dynamic data = diamondsData[i];
      final String lab = (data['Lab'] ?? '').toString().trim();
      final String shape = (data['Shape'] ?? '').toString().trim();
      final String color = (data['Color'] ?? '').toString().trim();
      final String clarity = (data['Clarity'] ?? '').toString().trim();
      final double carat = data['Carat'].toDouble();
      if ((AppDataModel.caratMin != null
              ? carat >= AppDataModel.caratMin!
              : true) &&
          (AppDataModel.caratMax != null
              ? carat <= AppDataModel.caratMax!
              : true) &&
          (AppDataModel.labSelectedType != 'None'
              ? AppDataModel.labSelectedType == lab
              : true) &&
          (AppDataModel.shapeSelectedType != 'None'
              ? AppDataModel.shapeSelectedType == shape
              : true) &&
          (AppDataModel.colorSelectedType != 'None'
              ? AppDataModel.colorSelectedType == color
              : true) &&
          (AppDataModel.claritySelectedType != 'None'
              ? AppDataModel.claritySelectedType == clarity
              : true)) {
        filterData.add(data);
      }
    }

    if (AppDataModel.finalPriceOrderType != 'None' ||
        AppDataModel.caratWeightOrderType != 'None') {
      filterData =
          filterData..sort((a, b) {
            final double amountA = double.parse(a['Final Amount'].toString());
            final double amountB = double.parse(b['Final Amount'].toString());
            final double caratA = double.parse(a['Carat'].toString());
            final double caratB = double.parse(b['Carat'].toString());
            int compare = 0;
            if (AppDataModel.finalPriceOrderType != 'None' &&
                AppDataModel.caratWeightOrderType == 'None') {
              compare =
                  AppDataModel.finalPriceOrderType == 'Ascending'
                      ? amountA.compareTo(amountB)
                      : amountB.compareTo(amountA);
            } else if (AppDataModel.finalPriceOrderType == 'None' &&
                AppDataModel.caratWeightOrderType != 'None') {
              compare =
                  AppDataModel.caratWeightOrderType == 'Ascending'
                      ? caratA.compareTo(caratB)
                      : caratB.compareTo(caratA);
            } else {
              // Carat Ascending, Amount Descending
              if (AppDataModel.caratWeightOrderType == 'Ascending' &&
                  AppDataModel.finalPriceOrderType == 'Descending') {
                compare = caratA.compareTo(caratB);
                if (compare == 0) {
                  compare = amountB.compareTo(amountA);
                }

                /// Carat Descending, Amount Ascending
              } else if (AppDataModel.caratWeightOrderType == 'Descending' &&
                  AppDataModel.finalPriceOrderType == 'Ascending') {
                compare = caratB.compareTo(caratA);
                if (compare == 0) {
                  compare = amountB.compareTo(amountA);
                }
              } else {
                compare =
                    AppDataModel.finalPriceOrderType == 'Ascending'
                        ? amountA.compareTo(amountB)
                        : amountB.compareTo(amountA);
              }
            }
            return compare;
          });
    }

    emit(
      DiamondSucessState(
        data: filterData,
        hasCartItems: (state as DiamondSucessState).hasCartItems,
      ),
    );
  }
}
