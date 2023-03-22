import 'dart:convert';

import 'package:http/http.dart' as http;

class Mail {
  static Future sendMail(String email, String subject, String message) async {
    const serviceID = 'service_ncobj6h';
    const templateID = 'template_x0dahte';
    const userID = 'J_oDzB3jiWgw1tMv1';
    const accessToken = '9_NDQ5EQ2k3QhVfkcdgth';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceID,
          'template_id': templateID,
          'user_id': userID,
          'accessToken': accessToken,
          'template_params': {
            'to_email': email,
            'user_subject': subject,
            'user_message': message,
          },
        }));
    print.call(response.body);
  }
}
