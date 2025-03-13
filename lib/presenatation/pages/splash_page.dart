import 'package:diamond_selection_app/business_logic/diamond_list/diamond_list_cubit.dart';
import 'package:diamond_selection_app/business_logic/splash/splash_cubit.dart';
import 'package:diamond_selection_app/business_logic/splash/splash_state.dart';
import 'package:diamond_selection_app/data/repositories/cart_item_repository.dart';
import 'package:diamond_selection_app/presenatation/pages/diamond_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SplashCubit>(context).init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashSucessState) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider(
                    create: (context) => DiamondListCubit(CartItemRepository()),
                    child: DiamondListPage(),
                  ),
            ),
          );
        }
      },
      builder:
          (context, state) => Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/kgk_group_logo.jpeg'),

                SizedBox(height: 100),
                if (state is SplashLoadingState)
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
              ],
            ),
          ),
    );
  }
}
