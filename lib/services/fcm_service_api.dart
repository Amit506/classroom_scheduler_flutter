import 'dart:convert';
import 'package:http/http.dart' as http;

class FcmServiceApi {
  static final fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  Future sendMessage(Map data) async {
    try {
      final msg = jsonEncode(data);
      Map<String, String> headers = {
        'content-type': 'application/json',
        'Authorization':
            'key=add server key here'
      };
      http.Response response =
          await http.post(Uri.parse(fcmUrl), headers: headers, body: msg);

      print(response.body);
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }
}
