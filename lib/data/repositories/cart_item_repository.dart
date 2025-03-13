import 'package:diamond_selection_app/services/local_storage_service.dart';

class CartItemRepository {
  Future<List<String>> getCartDataFromCache() async {
    final List<String> cartItemList =
        LocalStorageService.instance.getStringList('cart_items') ?? [];
    return cartItemList;
  }

  Future<List<String>> addCartDataIntoCache(dynamic data) async {
    final List<String> cartItemList = await getCartDataFromCache();
    cartItemList.add(data['Lot ID']);
    LocalStorageService.instance.setStringList('cart_items', cartItemList);
    return cartItemList;
  }

  Future<List<String>> removeCartDataFromCache(dynamic data) async {
    List<String> cartItemList = await getCartDataFromCache();
    cartItemList.removeAt(cartItemList.indexOf(data['Lot ID']));
    LocalStorageService.instance.setStringList('cart_items', cartItemList);
    return cartItemList;
  }
}
