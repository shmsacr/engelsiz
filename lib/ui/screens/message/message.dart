
import 'package:engelsiz/ui/screens/Message/avatar.dart';
import 'package:engelsiz/ui/screens/message/chat_screen.dart';
import 'package:engelsiz/ui/screens/message/widgets/display_eror_message.dart';
import 'package:engelsiz/ui/screens/message/widgets/icon_buttons.dart';
import 'package:engelsiz/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:jiffy/jiffy.dart';
import 'app.dart';
import 'helpers.dart';
import 'widgets/unread_indicator.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final channelListController = ChannelListController();

  @override
  Widget build(BuildContext context) {
    final filter = Filter.and([
      Filter.equal('type','messaging'),
      Filter.in_(
          'members', [
        StreamChatCore.of(context).currentUser!.id,
      ])
    ],);
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Sohpetler'),
        leadingWidth: 54,
        leading: Align(
          alignment: Alignment.centerRight,
          child: IconBackground(
            icon: Icons.search,
            onTap: () {
              print('TODO search');
            },
          ),
        ),
      ),
      body: ChannelsBloc(
        child: ChannelListCore(
          channelListController: channelListController,
          filter: filter,
          emptyBuilder: (context) => const Center(
            child: Text(
              'So empty',
              textAlign: TextAlign.center,
            ),
          ),
          errorBuilder: (context, error) => DisplayErrorMessage(error: error),
          loadingBuilder: (context) => const Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(),
            ),
          ),
          listBuilder: (context, channels) {
            return CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _MessageTitle(
                      channel: channels[index],
                    );
                  },
                  childCount: channels.length,
                )),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MessageTitle extends StatelessWidget {
  const _MessageTitle({Key? key, required this.channel}) : super(key: key);
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
         Navigator.of(context).push(ChatScreen.routeWithChannel(channel));
      },
      child: Container(
        height: 100,
        //margin: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 0.2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Avatar.large(
                    url: Helpers.getChannelImage(channel, context.currentUser!)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        Helpers.getChannelName(channel, context.currentUser!),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          letterSpacing: 0.2,
                          wordSpacing: 1.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _buildLastMessage(),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 4),
                    _buildLastMessageAt(),
                    const SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: UnreadIndicator(
                        channel: channel,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLastMessage() {
    return BetterStreamBuilder<int>(
      stream: channel.state!.unreadCountStream,
      initialData: channel.state?.unreadCount ?? 0 ,
      builder: (context,count){
            return BetterStreamBuilder<Message>(
              stream: channel.state!.lastMessageStream,
              initialData: channel.state!.lastMessage,
              builder: (context, lastMessage) {
                return Text(
                  lastMessage.text ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: (count > 0)
                      ? const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                  )
                      : const TextStyle(
                    fontSize: 12,
                    color: AppColors.textFaded,
                  ),
                );
              },
            );
      },
    );
  }

  Widget _buildLastMessageAt() {
    return BetterStreamBuilder<DateTime>(
      stream: channel.lastMessageAtStream,
      initialData: channel.lastMessageAt,
      builder: (context, data) {
        final lastMessageAt = data.toLocal();
        String stringDate;
        final now = DateTime.now();

        final startOfDay = DateTime(now.year, now.month, now.day);

        if (lastMessageAt.millisecondsSinceEpoch >=
            startOfDay.millisecondsSinceEpoch) {
          stringDate = Jiffy(lastMessageAt.toLocal()).jm;
        } else if (lastMessageAt.millisecondsSinceEpoch >=
            startOfDay
                .subtract(const Duration(days: 1))
                .millisecondsSinceEpoch) {
          stringDate = 'YESTERDAY';
        } else if (startOfDay.difference(lastMessageAt).inDays < 7) {
          stringDate = Jiffy(lastMessageAt.toLocal()).EEEE;
        } else {
          stringDate = Jiffy(lastMessageAt.toLocal()).yMd;
        }
        return Text(
          stringDate,
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: -0.2,
            fontWeight: FontWeight.w600,
            color: AppColors.textFaded,
          ),
        );
      },
    );
  }
}
