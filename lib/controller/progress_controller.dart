import 'dart:io';
import 'dart:ui';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import '../ui/screens/progress/filePreview.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseStorage storage = FirebaseStorage.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
late final Channel channel;
Future<String> uploadPDFToFirabase(File pdfFile) async{
  String pdfName = path.basename(pdfFile.path);
  Reference ref = storage.ref().child('progressMedia').child(auth.currentUser!.uid).child(pdfName);
  UploadTask uploadTask = ref.putFile(pdfFile);
  TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
  String downloadUrl = await taskSnapshot.ref.getDownloadURL();
  return downloadUrl;
}

Future<void> uploadPDF(BuildContext context) async{
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );
  if(result != null){
    File pdfFile = File(result.files.single.path ?? '');
    String pdfUrl = await uploadPDFToFirabase(pdfFile);

  }
}

