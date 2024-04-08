import 'package:flutter/material.dart';
import 'package:grocery_project/module/Customer_Side/provider/cart_provide.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CodToggle extends StatefulWidget {
  const CodToggle({super.key});

  @override
  State<CodToggle> createState() => _CodToggleState();
}

class _CodToggleState extends State<CodToggle> {
  bool _cod = false;

  @override
  Widget build(BuildContext context) {
    var _cart = Provider.of<CartProvider>(context);
    return Container(
      color: Colors.white,
      child: ToggleSwitch(
        minWidth: 150,
        cornerRadius: 20.0,
        activeBgColors: [
          [Colors.green],
          [Colors.green]
        ],
        activeFgColor: Colors.white,
        inactiveBgColor: Colors.grey[300],
        inactiveFgColor: Colors.grey[600],
        initialLabelIndex: _cod ? 1 : 0,
        totalSwitches: 2,
        labels: ['Pay Online', 'Cash On Delivery'],
        radiusStyle: true,
        onToggle: (index) {
          if (index == 0) {
            setState(() {
              _cod = false;
              _cart.getMethodToPay(0);
            });
          } else {
            setState(() {
              _cod = true;
              _cart.getMethodToPay(1);
            });
          }
          print('switched to: $index');
          print(_cod.toString(),);
        },
      ),
    );
  }
}
