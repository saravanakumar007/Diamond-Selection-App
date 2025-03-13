import 'package:diamond_selection_app/business_logic/cart_list/cart_list_state.dart';
import 'package:diamond_selection_app/data/models/app_data_model.dart';
import 'package:diamond_selection_app/data/repositories/cart_item_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartListCubit extends Cubit<CartListState> {
  CartListCubit(this.cartItemRepository) : super(CartInitialState());

  final CartItemRepository cartItemRepository;

  Future<void> fetchCardData() async {
    emit(CartLoadingState());
    final List<String> cartItemsCacheList =
        await cartItemRepository.getCartDataFromCache();
    final List<dynamic> cartItemsData = [];
    double totalPrice = 0;
    double totalCarat = 0;
    double totalDiscount = 0;
    for (int i = 0; i < AppDataModel.diamondData.length; i++) {
      final dynamic data = AppDataModel.diamondData[i];
      if (cartItemsCacheList.contains(data['Lot ID'])) {
        totalCarat += data['Carat'];
        totalPrice += data['Final Amount'];
        totalDiscount += data['Discount'];
        cartItemsData.add(data);
      }
    }
    emit(
      CartSucessState(
        data: cartItemsData,
        totalPrice: totalPrice,
        totalCarat: totalCarat,
        averagePrice: totalPrice / cartItemsData.length,
        averageDiscount: totalDiscount / cartItemsData.length,
      ),
    );
  }

  Future<void> removeItemFromCart(dynamic data) async {
    emit(CartLoadingState());
    await cartItemRepository.removeCartDataFromCache(data);
    fetchCardData();
  }
}
