import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/announcement_service.dart';
import '../models/user_model.dart';
import '../models/announcement_model.dart';
import '../services/polling_notification_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final AnnouncementService _announcementService = AnnouncementService();
  final PollingNotificationService _notificationService = PollingNotificationService();

  User? _user;
  bool _isAuthenticated = false;
  List<Announcement> _announcements = [];

  User? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  List<Announcement> get announcements => _announcements;

  Future<void> login(String email, String password) async {
    User? authenticatedUser = await _authService.login(email, password);
    if (authenticatedUser != null) {
      _user = authenticatedUser;
      _isAuthenticated = true;
      await loadAnnouncements();
      _notificationService.init(_user!.userId, loadAnnouncements); // Inicia la verificación de anuncios con el manejador de notificaciones
      notifyListeners();
    } else {
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  Future<void> loadAnnouncements() async {
    if (_user != null) {
      _announcements = await _announcementService.fetchUserAnnouncements(_user!.userId);
      notifyListeners();
    }
  }

  void logout() {
    _user = null;
    _isAuthenticated = false;
    _announcements = [];
    _notificationService.dispose();
    notifyListeners();
  }
}
