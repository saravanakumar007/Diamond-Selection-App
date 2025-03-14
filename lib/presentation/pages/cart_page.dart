import 'package:diamond_selection_app/business_logic/cart_list/cart_list_cubit.dart';
import 'package:diamond_selection_app/business_logic/cart_list/cart_list_state.dart';
import 'package:diamond_selection_app/presentation/widgets/diamond_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CartListCubit>(context).fetchCardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
        ),
        centerTitle: false,
        backgroundColor: Colors.green,
        title: Text(
          'Diamond List',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<CartListCubit, CartListState>(
        builder: (context, state) {
          if (state is CartInitialState || state is CartLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          } else if (state is CartSucessState) {
            return state.data.isNotEmpty
                ? ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(20),
                  itemBuilder:
                      (context, index) => DiamondCardWidget(
                        data: state.data[index],
                        index: index,
                        isCartPage: true,
                      ),
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                  itemCount: state.data.length,
                )
                : Center(
                  child: Text(
                    'No Data Found',
                    style: TextStyle(color: Colors.green, fontSize: 30),
                  ),
                );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
