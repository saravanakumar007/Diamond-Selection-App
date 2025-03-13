import 'package:diamond_selection_app/business_logic/splash/splash_cubit.dart';
import 'package:diamond_selection_app/presenatation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiamondSelectionApp extends StatelessWidget {
  const DiamondSelectionApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diamond Selection App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider(
        create: (context) => SplashCubit(),
        child: SplashPage(),
      ),
    );
  }
}
