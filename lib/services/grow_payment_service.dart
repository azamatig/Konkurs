import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:konkurs_app/screens/wallet_transfer.dart';

const paymentUrl = "https://sandbox.ps.grow.mybuilder.site/";

class GrowPaymentService {
  Future<dynamic> pay(double amount) async {
    return http
        .post('$paymentUrl/payment/checkout/redirect', body: <String, dynamic>{
          'merchant_id': '',
          'order_id': Uuid().v4(),
          'amount': amount,
          'order_desc': 'Give App',
          'signature': ''
        })
        .then((res) => res.body)
        .then((history) => print(history));
  }
}
