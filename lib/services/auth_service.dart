import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class AuthService {
  final String baseUrl =
      'http://10.0.2.2:5000/api/auth'; // Cambiar si es necesario

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );
      return _processResponse(response);
    } catch (e) {
      print('Error en Flutter (login): $e'); // Error en consola de Flutter
      return {'success': false, 'message': 'Error in login'};
    }
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
          'password': password,
        }),
      );
      return _processResponse(response);
    } catch (e) {
      print('Error en Flutter (register): $e'); // Error en consola de Flutter
      return {'success': false, 'message': 'Error in registration'};
    }
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(
          'Llamada exitosa en Flutter'); // Llamada exitosa en consola de Flutter
      return {'success': true, 'data': responseData};
    } else {
      print(
          'Error en Flutter: ${responseData['message']}'); // Error en consola de Flutter
      return {
        'success': false,
        'message': responseData['message'] ?? 'An error occurred'
      };
    }
  }

  Future<void> saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', user.token);
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);
    await prefs.setString('id', user.id);
  }

  Future<User?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final id = prefs.getString('id');
    final name = prefs.getString('name');
    final email = prefs.getString('email');
    final token = prefs.getString('jwt_token');

    //Decodifcar el token
    if (token != null) {
      final jwt = JWT.decode(token);
      final exp =
          jwt.payload['exp'] < DateTime.now().millisecondsSinceEpoch / 1000;
      if (exp == true) {
        await removeUser();
        return null;
      }
    }

    if (id != null && name != null && email != null && token != null) {
      return User(id: id, name: name, email: email, token: token);
    }
    return null;
  }

  Future<void> removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('id');
  }

  // Obtener perfil del usuario
  Future<Map<String, dynamic>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener el perfil del usuario');
    }
  }

  // Actualizar perfil del usuario
  Future<Map<String, dynamic>> updateUserProfile(
      String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al actualizar el perfil');
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}
