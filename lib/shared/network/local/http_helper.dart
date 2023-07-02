import 'dart:convert';
import 'package:http/http.dart' as http;

class OdooService {
  static const String baseUrl = 'https://0903-197-203-109-42.ngrok-free.app';
  static const String db = 'test_aymen';
  static const String username = 'benkhaled_aymen@hotmail.fr';
  static const String password = 'odoodbaymen';

  static Future<http.Response> _sendRequest(
      String path, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$path');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return response;
  }
}