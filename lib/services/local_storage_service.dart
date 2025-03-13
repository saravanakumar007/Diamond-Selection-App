import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences instance;

  Future<void> init() async {
    instance = await SharedPreferences.getInstance();
  }
}
