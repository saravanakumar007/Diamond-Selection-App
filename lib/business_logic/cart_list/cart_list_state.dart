sealed class CartListState {}

class CartInitialState extends CartListState {}

class CartLoadingState extends CartListState {}

class CartSucessState extends CartListState {
  CartSucessState({
    required this.data,
    required this.totalCarat,
    required this.totalPrice,
    required this.averageDiscount,
    required this.averagePrice,
  });
  final List<dynamic> data;
  final double totalCarat;
  final double totalPrice;
  final double averagePrice;
  final double averageDiscount;
}
