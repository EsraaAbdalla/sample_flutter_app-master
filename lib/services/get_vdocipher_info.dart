import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> getOTP() async {
  final String apiUrl =
      'https://dev.vdocipher.com/api/videos/537ac3597dd4a30242507f27c8c9f680/otp';

  final Map<String, dynamic> requestBody = {"ttl": 2592000};

  final Map<String, String> headers = {
    'Authorization':
        'Apisecret uKwPcycLZ7ZwR5TrEU3zK5k1vxS9ed7ElLxoYA7kU6FckscqZrTcrVHSpENRiBAZ',
    'Content-Type': 'application/json',
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      // Successful response, parse and return the data
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } else {
      // Handle error response
      print('Error: ${response.statusCode}, ${response.body}');
      return null;
    }
  } catch (error) {
    // Handle network error
    print('Network error: $error');
    return null;
  }
}
