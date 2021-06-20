import 'package:http/http.dart' as http;

const paymentUrl = "http://localhost:8080";

class GrowPaymentService {
  Future<dynamic> request(double amount) async {
    return http
        .post('$paymentUrl/api/v1/grow-payment/request',
            body: <String, dynamic>{
              'amount': amount,
            })
        .then((res) => res.body)
        .then((data) => print(data));
  }

  Future<dynamic> create(double amount, int adId) async {
    return http
        .post('$paymentUrl/api/v1/grow-payment/create', body: <String, dynamic>{
          'amount': amount,
          'adId': adId,
          'locale': 'ru'
        })
        .then((res) => res.body)
        .then((data) => print(data));
  }

  Future<dynamic> confirm(int invoiceId) async {
    return http
        .post('$paymentUrl/api/v1/grow-payment/request',
            body: <String, dynamic>{'invoiceId': invoiceId, 'locale': 'ru'})
        .then((res) => res.body)
        .then((data) => print(data));
  }

  Future<dynamic> status(int invoiceId) async {
    return http
        .post('$paymentUrl/api/v1/grow-payment/status',
            body: <String, dynamic>{'invoiceId': invoiceId, 'locale': 'ru'})
        .then((res) => res.body)
        .then((data) => print(data));
  }

  Future<dynamic> balance(int invoiceId) async {
    return http
        .post('$paymentUrl/api/v1/balance',
            body: <String, dynamic>{'invoiceId': invoiceId, 'locale': 'ru'})
        .then((res) => res.body)
        .then((data) => print(data));
  }
}
