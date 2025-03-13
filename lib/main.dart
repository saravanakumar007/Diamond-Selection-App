import 'package:diamond_selection_app/app.dart';
import 'package:diamond_selection_app/services/local_storage_service.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageService().init();
  runApp(const DiamondSelectionApp());
}
