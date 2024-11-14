// views/home_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import './CalendarView.dart';
import './AnnouncementDetailView.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final announcements = authProvider.announcements;

    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarView()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: user != null
          ? RefreshIndicator(
              onRefresh: () async {
                await authProvider.loadAnnouncements();
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido, ${user.name}',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Rol: ${user.role.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Anuncios:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[700],
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Expanded(
                      child: announcements.isNotEmpty
                          ? ListView.builder(
                              itemCount: announcements.length,
                              itemBuilder: (context, index) {
                                final announcement = announcements[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  child: ListTile(
                                    title: Text(
                                      announcement.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[800],
                                      ),
                                    ),
                                    subtitle: Text(
                                      announcement.message,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Text(
                                      announcement.sent ?? '',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AnnouncementDetailView(
                                                  announcement: announcement),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            )
                          : Center(child: Text('No se encontraron anuncios')),
                    ),
                  ],
                ),
              ),
            )
          : Center(child: Text('No se encontró la información del usuario')),
    );
  }
}
