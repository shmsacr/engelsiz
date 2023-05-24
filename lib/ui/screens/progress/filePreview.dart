import 'package:engelsiz/controller/progress_controller.dart';
import 'package:engelsiz/ui/screens/progress/progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class FilePreviewPage extends StatelessWidget {
  final PlatformFile file;

  FilePreviewPage({required this.file, required this.channel});
  final Channel channel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dosya Önizleme'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insert_drive_file, size: 80),
            SizedBox(height: 16),
            Text(
              'Dosya Adı: ${file.name}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () { uploadPDF(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProgressScreen(channel: channel,),
                ),
              );
              },
              child: Text('Dosyayı Kullan'),
            ),
          ],
        ),
      ),
    );
  }
}
