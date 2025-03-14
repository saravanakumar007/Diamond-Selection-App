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
    return BlocBuilder<CartListCubit, CartListState>(
      builder:
          (context, state) => Scaffold(
            backgroundColor: Colors.white,
            bottomNavigationBar: Builder(
              builder: (context) {
                return (state is CartSucessState &&
                        state.totalPrice > 0 &&
                        state.totalCarat > 0)
                    ? Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        color: Colors.green,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total Carat : ${state.totalCarat.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Total Price : ${state.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Average Price : ${state.averagePrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Average Discount : ${state.averageDiscount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    )
                    : SizedBox();
              },
            ),
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new),
                color: Colors.white,
              ),

              backgroundColor: Colors.green,
              title: Text(
                'Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Builder(
              builder: (context) {
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
                        separatorBuilder:
                            (context, index) => SizedBox(height: 20),
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
          ),
    );
  }
}
