// views/announcement_detail_view.dart
import 'package:flutter/material.dart';
import '../models/announcement_model.dart';
import '../services/attachment_service.dart.dart';

class AnnouncementDetailView extends StatelessWidget {
  final Announcement announcement;
  final AttachmentService attachmentService = AttachmentService();

  AnnouncementDetailView({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Anuncio'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              announcement.title,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.person, color: Colors.blue[600]),
                SizedBox(width: 8.0),
                Text(
                  'Emisor: ${announcement.emisor ?? 'Desconocido'}',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.blue[600]),
                SizedBox(width: 8.0),
                Text(
                  'Fecha: ${announcement.date ?? 'No especificada'}',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Icon(Icons.label, color: Colors.blue[600]),
                SizedBox(width: 8.0),
                Text(
                  'Tipo: ${announcement.type ?? 'General'}',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 24.0),
            Text(
              'Mensaje:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              announcement.message,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 24.0),
            if (announcement.attachments.isNotEmpty) ...[
              Text(
                'Archivos Adjuntos:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
              ...announcement.attachments.map((attachment) {
                return ListTile(
                  title: Text(attachment.name),
                  subtitle: Text('${attachment.fileSize} bytes'),
                  trailing: IconButton(
                    icon: Icon(Icons.download, color: Colors.blue),
                    onPressed: () async {
                      try {
                        await attachmentService.downloadAttachment(attachment.id, attachment.name);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Descarga de ${attachment.name} iniciada')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al descargar el archivo: $e')),
                        );
                      }
                    },
                  ),
                );
              }).toList(),
            ] else
              Center(child: Text('No hay archivos adjuntos')),
          ],
        ),
      ),
    );
  }
}
