import 'package:Buytime/reblox/model/order/order_state.dart';
import 'package:flutter/material.dart';

class OrderTotal extends StatelessWidget {
  const OrderTotal({
    @required this.orderState,
    Key key,
    @required this.media,
  }) : super(key: key);

  final Size media;
  final OrderState orderState;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      width: media.width,
      decoration: BoxDecoration(
        color: Color.fromRGBO(246, 246, 246, 1.0),
        border: Border(
          bottom: BorderSide(width: 1.0, color: Color.fromRGBO(33, 33, 33, 0.1)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Totale: € " + orderState.total.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: media.height * 0.026,
              ),
            ),
            Text(
              "IVA: € " + (orderState.total != null ? (orderState.total * 0.25).toStringAsFixed(2) : "0"),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: media.height * 0.020,
              ),
            ),
          ],
        ),
      ),
    );
  }
}