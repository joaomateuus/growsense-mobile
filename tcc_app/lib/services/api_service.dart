import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tcc_app/models/user_session.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8000';

  Future<http.Response?> post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final token = UserSession.getSession()?.access;

      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      // Verifica se o status é um código de erro
      if (response.statusCode >= 400) {
        print(
            "Erro na requisição POST: ${response.statusCode} - ${response.body}");
        return null;
      }

      return response;
    } catch (e) {
      print("Erro ao realizar a requisição POST: $e");
      return null;
    }
  }

  Future<http.Response?> get(String endpoint) async {
    try {
      final token = UserSession.getSession()?.access;

      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 400) {
        print(
            "Erro na requisição GET: ${response.statusCode} - ${response.body}");
        return null;
      }

      return response;
    } catch (e) {
      print("Erro ao realizar a requisição GET: $e");
      return null;
    }
  }

  Future<http.Response?> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final token = UserSession.getSession()?.access;

      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode >= 400) {
        print(
            "Erro na requisição PUT: ${response.statusCode} - ${response.body}");
        return null;
      }

      return response;
    } catch (e) {
      print("Erro ao realizar a requisição PUT: $e");
      return null;
    }
  }

  Future<http.Response?> delete(String endpoint) async {
    try {
      final token = UserSession.getSession()?.access;

      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 400) {
        print(
            "Erro na requisição DELETE: ${response.statusCode} - ${response.body}");
        return null;
      }

      return response;
    } catch (e) {
      print("Erro ao realizar a requisição DELETE: $e");
      return null;
    }
  }
}
