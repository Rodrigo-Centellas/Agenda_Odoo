// models/announcement_model.dart
class Announcement {
  final int id;
  final String title;
  final String message;
  final String? date;
  final String? type;
  final String? sent;
  final String? emisor;
  final List<Attachment> attachments;

  Announcement({
    required this.id,
    required this.title,
    required this.message,
    this.date,
    this.type,
    this.sent,
    this.emisor,
    required this.attachments,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      date: json['date'] as String?,
      type: json['type'] as String?,
      sent: json['sent'] as String?,
      emisor: json['emisor'] as String?,
      attachments: (json['attachments'] as List)
          .map((attachment) => Attachment.fromJson(attachment))
          .toList(),
    );
  }
}

class Attachment {
  final int id;
  final String name;
  String url;
  final int fileSize;
  final String mimetype;

  Attachment({
    required this.id,
    required this.name,
    required this.url,
    required this.fileSize,
    required this.mimetype,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'] as int,
      name: json['name'] as String,
      url: json['url'] as String,
      fileSize: json['file_size'] as int,
      mimetype: json['mimetype'] as String,
    );
  }
}
