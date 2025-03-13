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
    final List<dynamic> filterData = [];
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

    if (AppDataModel.finalPriceOrderType != 'None') {
      filterData.sort((a, b) {
        return AppDataModel.finalPriceOrderType == 'Ascending'
            ? double.parse(
              a['Final Amount'].toString(),
            ).compareTo(double.parse(b['Final Amount'].toString()))
            : double.parse(
              b['Final Amount'].toString(),
            ).compareTo(double.parse(a['Final Amount'].toString()));
      });
    }

    if (AppDataModel.caratWeightOrderType != 'None') {
      filterData.sort((a, b) {
        return AppDataModel.finalPriceOrderType == 'Ascending'
            ? double.parse(
              a['Carat'].toString(),
            ).compareTo(double.parse(b['Carat'].toString()))
            : double.parse(
              b['Carat'].toString(),
            ).compareTo(double.parse(a['Carat'].toString()));
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
