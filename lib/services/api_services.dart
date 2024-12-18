import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // Update this with your backend URL. For local testing, use something like:
  // "http://10.0.2.2:3000" if you're testing on Android emulator.
  // If deployed to Cloud Run or another host, use that URL.
  static const String baseUrl = "http://localhost:3000";

  static Future<Map<String, dynamic>?> analyzeImage(File image) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/analyze'));
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      
      var response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        return json.decode(res.body) as Map<String, dynamic>?;
      } else {
        print('Error: Received status code ${response.statusCode} from server.');
        return null;
      }
    } catch (e) {
      print('Error in analyzeImage: $e');
      return null;
    }
  }
}
