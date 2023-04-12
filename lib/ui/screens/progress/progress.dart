import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engelsiz/controller/auth_controller.dart';
import 'package:engelsiz/ui/screens/message/app.dart';
import 'package:engelsiz/ui/screens/progress/progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../Message/avatar.dart';
import '../message/contacts_button/contacts_list.dart';
import '../message/widgets/display_eror_message.dart';

class _ProgressState extends ConsumerState<Progress> {
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => const Dialog(
              child: AspectRatio(
                aspectRatio: 8 / 7,
                child: ContactsList(),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: PagedValueListenableBuilder<int, Channel>(
        valueListenable: channelListController,
        builder: (context, currentUser, child) {
          return currentUser.when(
            (channels, nextPageKey, error) {
              if (channels.isEmpty) {
                return const Center(
                  child: Text(
                    'So empty.\nGo and message someone.',
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return LazyLoadScrollView(
                onEndOfPage: () async {
                  if (nextPageKey != null) {
                    channelListController.loadMore(nextPageKey);
                  }
                },
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _MessageTitle(
                            channel: channels[index],
                          );
                        },
                        childCount: channels.length,
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e) => DisplayErrorMessage(
              error: e,
            ),
          );
        },
      ),
    );
    ;
  }
}

class _MessageTitle extends ConsumerWidget {
  const _MessageTitle({Key? key, required this.channel}) : super(key: key);
  final Channel channel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProgressScreen()));
      },
      child: Container(
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
          child: FutureBuilder(
            future: getUserName(channel, context.currentUser!, ref),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                var data = snapshot.data?.data() as Map<String, dynamic>;
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Avatar.medium(
                          url: data['profilePicture'] ??
                              'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg'),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(data['fullName']),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
                children = <Widget>[
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Result: ${snapshot.data}'),
                  ),
                ];
              } else if (snapshot.hasError) {
                return CircularProgressIndicator();
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
