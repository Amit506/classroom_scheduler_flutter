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
            'key=AAAAG0PJQsI:APA91bHRAevpUEERz7BQysMMmNxMnFa5KG1ai6I67dpFoTUpCPBMg6QD7oD7mMR-9qoR3eGQCZyy9N-7bAIHF42ULV4hCDkGQRszxtiEb8Mrc7rNqSr7M2ieH_4lVT3J_sr5YeFpm5qZ'
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
