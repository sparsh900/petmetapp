import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

const String key_secret = "0PFGwg69u1f9cNnAYSBCkh8r";
const String key_ID = "rzp_test_HpdJifpKFyBE1U";

Future<String> generateOrderId(String key, String secret, int amount) async {
  var authn = 'Basic ' + base64Encode(utf8.encode('$key:$secret'));

  var headers = {
    'content-type': 'application/json',
    'Authorization': authn,
  };

  var data =
      '{ "amount": $amount, "currency": "INR", "receipt": "receipt#R1", "payment_capture": 1 }'; // as per my experience the receipt doesn't play any role in helping you generate a certain pattern in your Order ID!!

  var res = await http.post('https://api.razorpay.com/v1/orders', headers: headers, body: data);
  if (res.statusCode != 200) throw Exception('http.post error: statusCode= ${res.statusCode}');
  print('ORDER ID response => ${res.body}');

  return json.decode(res.body)['id'].toString();
}

void handlePaymentSuccess(PaymentSuccessResponse response) {
  var secret = utf8.encode(key_secret);
  var bytes = utf8.encode("${response.orderId}|${response.paymentId}");
  var hMacSha256 = new Hmac(sha256, secret);
  Digest generatedSignature = hMacSha256.convert(bytes);

  print("$generatedSignature");
  print(response.signature);

  if ("$generatedSignature" == response.signature) {
    print("Successfulll");
    // widget.database.updateOrder(order,"successful",orderID);
    // widget.database.deleteAllCartItems();
  }
}
