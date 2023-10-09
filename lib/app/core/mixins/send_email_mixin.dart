import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

mixin Send_Email_Mixin on GetxController {
  // Future sendEmail(
  //     {required String name,
  //     required String email,
  //     required String subject,
  //     required String message}) async {
  //   const serviceId = 'service_sl4hgh4';
  //   const templateId = 'template_1knuh3f';
  //   const userId = 'user_Koa6snXKgKOUazggP';

  //   // final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

  //   try {
  //     final response = await Dio()
  //         .post('https://api.emailjs.com/api/v1.0/email/send', data: {
  //       'service_id': serviceId,
  //       'template_id': templateId,
  //       'user_id': userId,
  //       'template_params': {
  //         'user_name': name,
  //         'user_email': email,
  //         'user_subject': subject,
  //         'user_message': message,
  //       }
  //     });
  //     print('deu cetrto');
  //     print(response);
  //   } catch (e) {
  //     print('deu errado');
  //     print(e);
  //   }

  //   // print(response.data);
  // }

  Future sendEmail({
    required String assunto,
    required String para,
    required String mensagem,
  }) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = 'service_sl4hgh4';
    const templateId = 'template_1knuh3f';
    const userId = 'Koa6snXKgKOUazggP';
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json'
        }, //This line makes sure it works for all platforms.
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'assunto': assunto,
            'para': para,
            'mensagem': mensagem,
          }
        }));
    print('#############');
    print(response.statusCode);
    return response.statusCode;
  }
}
