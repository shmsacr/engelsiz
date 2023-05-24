


import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engelsiz/ui/screens/message/app.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import '../../../controller/auth_controller.dart';
import '../../../controller/progress_controller.dart';
import '../Message/avatar.dart';
import '../message/widgets/icon_buttons.dart';
import 'filePreview.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({Key? key, required this.channel}) : super(key: key);
  final Channel channel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 54,
          leading: Align(
            alignment: Alignment.centerRight,
            child: IconBackground(
              icon: CupertinoIcons.back,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          title: _AppBarTitle(channel: channel),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Center(
                child: IconBorder(
                  icon: CupertinoIcons.video_camera_solid,
                  onTap: () {},
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Center(
                child: IconBorder(
                  icon: CupertinoIcons.phone_solid,
                  onTap: () {},
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                      child: AspectRatio(
                          aspectRatio: 7 / 6,
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Column(
                              children: [
                                const Text(
                                  "Dosya Türünü Seçiniz",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                  textAlign: TextAlign.left,
                                ),
                                const ListTile(
                                  leading: Icon(Icons.camera_alt),
                                  title: Text("Kamera ile gönder"),
                                ),
                                const ListTile(
                                  leading: Icon(Icons.photo_library_rounded),
                                  title: Text("Galeriyi aç"),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.file_copy_sharp),
                                  title: const Text("Belge gönder"),
                                  onTap: () async {
                                    FilePickerResult? result = await FilePicker.platform.pickFiles();
                                    PlatformFile file = result!.files.first;
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                    MaterialPageRoute(
                                        builder: (context) => FilePreviewPage(file: file, channel: channel,),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ))));
            },
            child: const Icon(Icons.file_copy_sharp)),
      ),
    );
  }

  openFile(PlatformFile file){
    OpenFile.open(file.path!);
  }
}

class _AppBarTitle extends ConsumerWidget {
  const _AppBarTitle({Key? key, required this.channel}) : super(key: key);
  final Channel channel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
        future: getUserName(channel, context.currentUser!, ref),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data?.data() as Map<String, dynamic>;
            return TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  Avatar.small(
                    url: data['profilePicture'] ??
                        'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg',
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['fullName']),
                        const SizedBox(height: 2),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const CircularProgressIndicator();
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
