import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_core/firebase_core.dart';

import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
as stream_chat;
import 'auth_controller.dart';

Future<String> uploadPDFToFirebase(File pdfFile,stream_chat.Channel channel,
    stream_chat.User currentUser, WidgetRef ref) async {
  final otherMembers = channel.state?.members.where(
        (element) => element.userId != currentUser.id,
  );
  final parentId = otherMembers!.first.userId;
  String pdfName = path.basename(pdfFile.path);
  Reference ref = FirebaseStorage.instance.ref()
      .child('progressMedia')
      .child(parentId!)
      .child(pdfName);
  UploadTask uploadTask = ref.putFile(pdfFile);
  TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
  String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  return downloadUrl;
}

Future<void> uploadPDF(stream_chat.Channel channel,
    stream_chat.User currentUser, WidgetRef ref) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );
  if (result != null) {
    File pdfFile = File(result.files.single.path!);
    String pdfUrl = await uploadPDFToFirebase(pdfFile, channel, currentUser, ref);
    print('PDF download URL: $pdfUrl');
  }
}



