import 'package:diamond_selection_app/business_logic/cart_list/cart_list_cubit.dart';
import 'package:diamond_selection_app/business_logic/diamond_list/diamond_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiamondWidget extends StatelessWidget {
  const DiamondWidget({
    super.key,
    this.data,
    required this.index,
    this.isCartPage = false,
  });
  final int index;
  final dynamic data;
  final bool isCartPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            spreadRadius: 1,
            blurRadius: 2,
            color: Colors.green,
          ),
        ],
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            width: 80,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 10),
                  spreadRadius: 0,
                  blurRadius: 10,
                  color: Colors.grey,
                ),
              ],
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Image.asset('assets/images/${(index % 5) + 1}.png'),
          ),
          SizedBox(width: 20),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID : ${data['Lot ID']}'),
                SizedBox(height: 5),
                Text('Size : ${data['Size']}'),
                SizedBox(height: 5),
                Text('Carat : ${data['Carat']}'),
                SizedBox(height: 5),
                Text('Discount : ${data['Discount']}'),
                SizedBox(height: 5),
                Text('Per Carat Rate : ${data['Discount']}'),
                SizedBox(height: 5),
                if ((data['Key To Symbol'] ?? '')
                    .toString()
                    .trim()
                    .isNotEmpty) ...[
                  Flexible(
                    child: Text('Key to Symbol : ${data['Key To Symbol']}'),
                  ),
                ],
                SizedBox(height: 5),
                if ((data['Lab Comment'] ?? '')
                    .toString()
                    .trim()
                    .isNotEmpty) ...[
                  Flexible(child: Text('Lab Comment : ${data['Lab Comment']}')),
                ],
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      if (isCartPage) {
                        BlocProvider.of<CartListCubit>(
                          context,
                        ).removeItemFromCart(data);
                      } else {
                        BlocProvider.of<DiamondListCubit>(
                          context,
                        ).addItemIntoCart(data);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color:
                            isCartPage
                                ? Colors.green
                                : data['cartAdded']
                                ? Colors.green.shade100.withValues(alpha: 0.6)
                                : Colors.green,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          isCartPage
                              ? 'Remove From Cart'
                              : data['cartAdded']
                              ? 'Added'
                              : 'Add to Cart',
                          style: TextStyle(
                            color:
                                isCartPage
                                    ? Colors.white
                                    : data['cartAdded']
                                    ? Colors.green
                                    : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
