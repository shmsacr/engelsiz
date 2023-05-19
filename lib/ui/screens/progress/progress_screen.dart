import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engelsiz/ui/screens/message/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../../../controller/auth_controller.dart';
import '../Message/avatar.dart';
import '../message/widgets/icon_buttons.dart';

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
      ),
    );
    ;
  }
}
// class ProgressScreen extends StatefulWidget {
//   const ProgressScreen({Key? key,required this.channel}) : super(key: key);
//   final Channel channel;
//   @override
//   State<ProgressScreen> createState() => _ProgressScreenState();
// }

// class _ProgressScreenState extends State<ProgressScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           leadingWidth: 54,
//           leading: Align(
//             alignment: Alignment.centerRight,
//             child: IconBackground(
//               icon: CupertinoIcons.back,
//               onTap: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ),
//           title: const _AppBarTitle(channel: ,),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Center(
//                 child: IconBorder(
//                   icon: CupertinoIcons.video_camera_solid,
//                   onTap: () {},
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 20),
//               child: Center(
//                 child: IconBorder(
//                   icon: CupertinoIcons.phone_solid,
//                   onTap: () {},
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
            return CircularProgressIndicator();
          } else {
            return CircularProgressIndicator();
          }
        });
    ;
  }
}
