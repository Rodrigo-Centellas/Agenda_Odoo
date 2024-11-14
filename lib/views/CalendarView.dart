// views/calendar_view.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import './AnnouncementDetailView.dart';

class CalendarView extends StatefulWidget {
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  late Map<DateTime, List<dynamic>> _events;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<dynamic> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _events = {};
    _selectedEvents = [];
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final announcements = authProvider.announcements;

    Map<DateTime, List<dynamic>> eventMap = {};

    // Agregar anuncios al mapa de eventos
    for (var announcement in announcements) {
      if (announcement.date != null) {
        try {
          DateTime announcementDate = DateFormat('yyyy-MM-dd').parse(announcement.date!);
          (eventMap[announcementDate] ??= []).add({
            'type': 'Anuncio',
            'title': announcement.title,
            'description': announcement.message,
            'data': announcement,
          });
        } catch (e) {
          print("Error al parsear la fecha: ${announcement.date}");
        }
      }
    }

    setState(() {
      _events = eventMap;
      _selectedEvents = _getEventsForDay(_selectedDay);
    });
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents = _getEventsForDay(selectedDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendario de Anuncios"),
        backgroundColor: Colors.blue[800],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 1, 1),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsForDay,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: _selectedEvents.isNotEmpty
                ? ListView.builder(
                    itemCount: _selectedEvents.length,
                    itemBuilder: (context, index) {
                      final event = _selectedEvents[index];
                      return ListTile(
                        leading: Icon(
                          Icons.announcement,
                          color: Colors.green,
                        ),
                        title: Text(
                          event['title'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800]),
                        ),
                        subtitle: Text(
                          event['description'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AnnouncementDetailView(
                                      announcement: event['data']),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Center(child: Text('No hay eventos para esta fecha')),
          ),
        ],
      ),
    );
  }
}
