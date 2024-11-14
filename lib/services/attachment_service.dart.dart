// services/attachment_service.dart
import 'package:url_launcher/url_launcher.dart';

class AttachmentService {
  final String baseUrl = 'http://192.168.56.1:8069'; // Ajusta con tu URL base

  Future<void> downloadAttachment(int attachmentId, String filename) async {
    final downloadUrl =
        '$baseUrl/web/content/?model=ir.attachment&id=$attachmentId&filename_field=name&field=datas&download=true&name=$filename';

    if (await canLaunch(downloadUrl)) {
      await launch(downloadUrl);
    } else {
      throw 'Could not launch $downloadUrl';
    }
  }
}
