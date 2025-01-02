import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event.dart';

class ApiService {
  static const String baseUrl = 'https://halalapp.info/api';
  static const String apiKey = 'base64:fUIm86z3bfhx/X1UbNZVWB3O80v/iWQsXpB4B2IPej0=';

  Future<bool> addEvent(Event event) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addjsondata/3'),
        headers: {
          'X-API-Key': apiKey,
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        encoding: Encoding.getByName('utf-8'),
        body: event.toMap(),
      ).timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to add event: ${response.statusCode}\nResponse: ${response.body}');
      }
    } catch (e) {
      print('Error details: $e');
      throw Exception('Error adding event: $e');
    }
  }

  Future<List<Event>> getEvents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getjsondata/3'),
        headers: {
          'X-API-Key': apiKey,
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decodedBody = const Utf8Decoder().convert(response.bodyBytes);
        List<dynamic> data = jsonDecode(decodedBody);
        return data.map((json) => Event.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error loading events: $e');
    }
  }
}