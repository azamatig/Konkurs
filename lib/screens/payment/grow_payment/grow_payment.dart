import 'package:flutter/material.dart';

class GrowPayment extends StatefulWidget {
  GrowPayment({Key key}) : super(key: key);

  @override
  _GrowPaymentState createState() => _GrowPaymentState();
}

class _GrowPaymentState extends State<GrowPayment> {
  TextEditingController _amountController;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Amount'),
          controller: _amountController,
        ),
        Container(
            child: TextButton.icon(
                onPressed: _onSendRequest,
                icon: Icon(Icons.send),
                label: Text('Send request')))
      ],
    )));
  }

  void _onSendRequest() {}
}
