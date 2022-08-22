import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../Message/avatar.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late final channelListController = StreamChannelListController(
    client: StreamChatCore.of(context).client,
    filter: Filter.and(
      [
        Filter.equal('type', 'messaging'),
        Filter.in_(
          'members',
          [
            StreamChatCore.of(context).currentUser!.id,
          ],
        ),
      ],
    ),
  );
  @override
  void initState() {
    channelListController.doInitialLoad();
    super.initState();
  }

  @override
  void dispose() {
    channelListController.dispose();
    super.dispose();
  }

  final Stream<QuerySnapshot> userName =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: userName,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return InkWell(
          onTap: () {
//         //Navigator.of(context).push(ChatScreen.routeWithChannel(channel));
          },
          child: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Container(
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Avatar.medium(url: '${data['profilPicture']}'),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                '${data['fullName']}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  letterSpacing: 0.2,
                                  wordSpacing: 1.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                              //child: _buildLastMessage(),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            SizedBox(
                              height: 4,
                            ),
                            //_buildLastMessageAt(),
                            SizedBox(
                              height: 8,
                            ),
                            // Center(
                            //   child: UnreadIndicator(
                            //     channel: channel,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
  //   return PagedValueListenableBuilder<int, Channel>(
  //     valueListenable: channelListController,
  //     builder: (context, value, child) {
  //       return value.when(
  //         (channels, nextPageKey, error) {
  //           if (channels.isEmpty) {
  //             return const Center(
  //               child: Text(
  //                 'So empty.\nGo and message someone.',
  //                 textAlign: TextAlign.center,
  //               ),
  //             );
  //           }
  //           return LazyLoadScrollView(
  //             onEndOfPage: () async {
  //               if (nextPageKey != null) {
  //                 channelListController.loadMore(nextPageKey);
  //               }
  //             },
  //             child: CustomScrollView(
  //               slivers: [
  //                 SliverList(
  //                   delegate: SliverChildBuilderDelegate(
  //                     (context, index) {
  //                       return _MessageTitle(
  //                         channel: channels[index],
  //                       );
  //                     },
  //                     childCount: channels.length,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //         loading: () => const Center(
  //           child: SizedBox(
  //             height: 100,
  //             width: 100,
  //             child: CircularProgressIndicator(),
  //           ),
  //         ),
  //         error: (e) => DisplayErrorMessage(
  //           error: e,
  //         ),
  //       );
  //     },
  //   );
  // }
}

// class _MessageTitle extends StatelessWidget {
//   const _MessageTitle({Key? key, required this.channel}) : super(key: key);
//   final Channel channel;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         //Navigator.of(context).push(ChatScreen.routeWithChannel(channel));
//       },
//       child: Container(
//         height: 100,
//         margin: const EdgeInsets.symmetric(horizontal: 8),
//         decoration: const BoxDecoration(
//           border: Border(
//             bottom: BorderSide(
//               color: Colors.grey,
//               width: 0.5,
//             ),
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: Row(
//             children: [
//               const Padding(
//                 padding: EdgeInsets.all(10.0),
//                 child: Avatar.medium(
//                     url:
//                         'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg'),
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 8.0),
//                       child: Text(
//                         'Ahmet Mehmet',
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           letterSpacing: 0.2,
//                           wordSpacing: 1.5,
//                           fontWeight: FontWeight.w900,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                       //child: _buildLastMessage(),
//                     )
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 20.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     const SizedBox(
//                       height: 4,
//                     ),
//                     //_buildLastMessageAt(),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Center(
//                       child: UnreadIndicator(
//                         channel: channel,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Widget _buildLastMessage() {
//   //   return BetterStreamBuilder<int>(
//   //     stream: channel.state!.unreadCountStream,
//   //     initialData: channel.state?.unreadCount ?? 0,
//   //     builder: (context, count) {
//   //       return BetterStreamBuilder<Message>(
//   //         stream: channel.state!.lastMessageStream,
//   //         initialData: channel.state!.lastMessage,
//   //         builder: (context, lastMessage) {
//   //           return Text(
//   //             lastMessage.text ?? '',
//   //             overflow: TextOverflow.ellipsis,
//   //             style: (count > 0)
//   //                 ? const TextStyle(
//   //                     fontSize: 12,
//   //                     color: AppColors.secondary,
//   //                   )
//   //                 : const TextStyle(
//   //                     fontSize: 12,
//   //                     color: AppColors.textFaded,
//   //                   ),
//   //           );
//   //         },
//   //       );
//   //     },
//   //   );
//   // }
//   //
//   // Widget _buildLastMessageAt() {
//   //   return BetterStreamBuilder<DateTime>(
//   //     stream: channel.lastMessageAtStream,
//   //     initialData: channel.lastMessageAt,
//   //     builder: (context, data) {
//   //       final lastMessageAt = data.toLocal();
//   //       String stringDate;
//   //       final now = DateTime.now();
//   //
//   //       final startOfDay = DateTime(now.year, now.month, now.day);
//   //
//   //       if (lastMessageAt.millisecondsSinceEpoch >=
//   //           startOfDay.millisecondsSinceEpoch) {
//   //         stringDate = Jiffy(lastMessageAt.toLocal()).jm;
//   //       } else if (lastMessageAt.millisecondsSinceEpoch >=
//   //           startOfDay
//   //               .subtract(const Duration(days: 1))
//   //               .millisecondsSinceEpoch) {
//   //         stringDate = 'YESTERDAY';
//   //       } else if (startOfDay.difference(lastMessageAt).inDays < 7) {
//   //         stringDate = Jiffy(lastMessageAt.toLocal()).EEEE;
//   //       } else {
//   //         stringDate = Jiffy(lastMessageAt.toLocal()).yMd;
//   //       }
//   //       return Text(
//   //         stringDate,
//   //         style: const TextStyle(
//   //           fontSize: 11,
//   //           letterSpacing: -0.2,
//   //           fontWeight: FontWeight.w600,
//   //           color: AppColors.textFaded,
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }
// }
