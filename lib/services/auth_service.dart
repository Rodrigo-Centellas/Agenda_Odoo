// services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  // URL base manual
  final String baseUrl = 'http://192.168.56.1:8069';

  Future<User?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/authenticate');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data != null && data['result'] != null && data['result']['data'] != null) {
          return User.fromJson(data['result']['data']);
        } else {
          print('Datos de usuario no encontrados en la respuesta');
          return null;
        }
      } else {
        print('Error en la autenticación: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error de conexión: $e');
      return null;
    }
  }
}
