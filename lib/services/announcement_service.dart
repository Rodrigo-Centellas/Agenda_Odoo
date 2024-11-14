// services/announcement_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/announcement_model.dart';

class AnnouncementService {
  final String baseUrl = 'http://192.168.56.1:8069/api';
  final String contentBaseUrl = 'http://192.168.56.1:8069'; // Ajusta con tu URL base

  Future<List<Announcement>> fetchUserAnnouncements(int userId) async {
    final url = Uri.parse('$baseUrl/announcements/$userId'); // Pasando el userId de res.users
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['announcements'] != null) {
          return (data['announcements'] as List)
              .map((json) {
                // Modifica cada attachment para añadir el contentBaseUrl
                var announcement = Announcement.fromJson(json);
                for (var attachment in announcement.attachments) {
                  attachment.url = '${contentBaseUrl}${attachment.url}';
                }
                return announcement;
              })
              .toList();
        } else {
          print('No announcements found for user with ID: $userId');
          return [];
        }
      } else {
        throw Exception('Error fetching announcements');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
