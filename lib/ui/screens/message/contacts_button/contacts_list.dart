import 'package:engelsiz/data/models/user_with_id.dart';
import 'package:engelsiz/ui/screens/Message/avatar.dart';
import 'package:engelsiz/ui/screens/message/contacts_button/riverpod_contacts/riverpod_contacts.dart';
import 'package:engelsiz/ui/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class ContactsList extends ConsumerStatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _ContactsPageState();
}

class _ContactsPageState extends ConsumerState<ContactsList> {
  // FirebaseStorage storage = FirebaseStorage.instance;
  // final _firestore = FirebaseFirestore.instance;
  // Stream<QuerySnapshot> usersId =
  //     FirebaseFirestore.instance.collection('users').snapshots();
  //
  // String? picUrl;
  // var fullName = 'loading...';
  // var role = 'loading...';
  // var gender = 'loading...';
  // var phoneNumber = 'loading';
  // var stName = 'loading...';
  // void loadUserData() {
  //   _firestore.collection('users').doc().get().then((snapshot) {
  //     setState(() {
  //       fullName = snapshot.data()!['fullName'];
  //       role = snapshot.data()!['role'];
  //       gender = snapshot.data()!['gender'];
  //       phoneNumber = snapshot.data()!['phoneNumber'];
  //     });
  //   });
  // }

  late final userListController = StreamUserListController(
    client: StreamChatCore.of(context).client,
    limit: 20,
    filter: Filter.notEqual('id', StreamChatCore.of(context).currentUser!.id),
  );

  @override
  void initState() {
    userListController.doInitialLoad();
    super.initState();
  }

  @override
  void dispose() {
    userListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contactUsers = ref.watch(usersProvider);
    return contactUsers.when(
        data: (data) => ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return _ContactTile(
                  user: data[index],
                );
              },
            ),
        error: (error, _) => Text(error.toString()),
        loading: () => CircularProgressIndicator());
    // return PagedValueListenableBuilder<int, User>(
    //   valueListenable: contactUsers.value.length,
    //   builder: (context, value, child) {
    //     return value.when(
    //       (users, nextPageKey, error) {
    //         if (users.isEmpty) {
    //           return const Center(child: Text('There are no users'));
    //         }
    //         return LazyLoadScrollView(
    //           onEndOfPage: () async {
    //             if (nextPageKey != null) {
    //               userListController.loadMore(nextPageKey);
    //             }
    //           },
    //           child: ListView.builder(
    //             itemCount: users.length,
    //             itemBuilder: (context, index) {
    //               return _ContactTile(user: users[index]);
    //             },
    //           ),
    //         );
    //       },
    //       loading: () => const Center(child: CircularProgressIndicator()),
    //       error: (e) => DisplayErrorMessage(error: e),
    //     );
    //   },
    // );
  }
}

class _ContactTile extends StatefulWidget {
  const _ContactTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserWithId user;
  // const _ContactTile({
  //   Key? key,
  //   required this.userId,
  //   required this.picUrl,
  //   required this.user,
  // }) : super(key: key);
  //
  // final String user;
  // final String picUrl;
  // final String userId;

  @override
  State<_ContactTile> createState() => _ContactTileState();
}

class _ContactTileState extends State<_ContactTile> {
  Future<void> createChannel(BuildContext context) async {
    final core = StreamChatCore.of(context);
    final nav = Navigator.of(context);
    final channel = core.client.channel('messaging', extraData: {
      'members': [core.currentUser!.id, widget.user.id]
    });
    await channel.watch();

    nav.push(
      ChatScreen.routeWithChannel(channel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        createChannel(context);
      },
      child: ListTile(
        leading: Avatar.small(url: widget.user.user.profilePicture),
        title: Text(widget.user.user.fullName),
      ),
    );
  }
}
