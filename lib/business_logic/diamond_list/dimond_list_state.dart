sealed class DiamondListState {}

class DiamondInitialState extends DiamondListState {}

class DiamondLoadingState extends DiamondListState {}

class DiamondSucessState extends DiamondListState {
  DiamondSucessState({required this.data, required this.hasCartItems});
  final List<dynamic> data;
  final bool hasCartItems;
}
