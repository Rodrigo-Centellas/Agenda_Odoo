import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/announcement_model.dart';
import '../services/announcement_service.dart';

class PollingNotificationService {
  final AnnouncementService _announcementService = AnnouncementService();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Timer? _timer;
  int? _userId;

  final Set<int> _notifiedAnnouncementIds = {};

  void init(int userId, Function onNotificationTap) {
    _userId = userId;
    _startPolling();

    // Configuración inicial para la notificación con manejo de respuesta
    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher')),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          onNotificationTap(); // Llama a la función de actualización de anuncios
        }
      },
    );
  }

  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (_userId != null) {
        await _checkForNewAnnouncements(_userId!);
      }
    });
  }

  Future<void> _checkForNewAnnouncements(int userId) async {
    try {
      List<Announcement> announcements = await _announcementService.fetchUserAnnouncements(userId);

      for (var announcement in announcements) {
        if (!_notifiedAnnouncementIds.contains(announcement.id)) {
          _sendNotification(announcement);
          _notifiedAnnouncementIds.add(announcement.id);
        }
      }
    } catch (e) {
      print("Error fetching announcements: $e");
    }
  }

  Future<void> _sendNotification(Announcement announcement) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      announcement.id,
      'Nuevo Anuncio: ${announcement.title}',
      announcement.message,
      platformChannelSpecifics,
      payload: announcement.id.toString(),
    );
  }

  void dispose() {
    _timer?.cancel();
  }
}
