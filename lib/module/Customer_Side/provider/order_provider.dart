import 'package:flutter/foundation.dart';

class OrderProvider with ChangeNotifier {
  String status = "";
  String amount = "";
  String shopName = "";
  bool success = false;
  filterOrder(status) {
    this.status = status;
    notifyListeners();
  }

  totalPayment(amount,shopName)
  {
    this.amount = amount.toStringAsFixed(0);
    this.shopName = shopName;
    notifyListeners();
  }pamentStatus(success)
  {
   this.success = success;
    notifyListeners();
  }
}
