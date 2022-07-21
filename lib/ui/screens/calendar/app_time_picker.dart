import 'package:engelsiz/data/models/meeting_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engelsiz/utils/datetime_ext.dart';

import 'package:engelsiz/controller/calendar_controller.dart';

class AppTimePicker extends ConsumerWidget {
  // final AppointmentNotifier appointmentNotifier;
  final Meeting? meeting;

  const AppTimePicker({this.meeting, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cupertinoTextStyle = Theme.of(context).textTheme.headlineSmall;
    final meetingController = ref.watch(meetingProvider(meeting));
    final meetingNotifier = ref.watch(meetingProvider(meeting).notifier);

    return Container(
      height: 216,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Material(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child: Container()),
            Flexible(
              flex: 2,
              child: CupertinoPicker(
                itemExtent: 36,
                scrollController: FixedExtentScrollController(
                  initialItem: meeting == null ? 1 : meeting!.start.hour - 8,
                ),
                onSelectedItemChanged: (value) {
                  meetingNotifier.updateStartTime(
                    DateTimeExt(meetingController.start)
                        .copyWith(hour: value + 8),
                  );
                },
                children: List<Widget>.generate(
                  10,
                  (int index) => Material(
                    type: MaterialType.transparency,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 24.0),
                        child: Text(
                          (index + 8).toString().padLeft(2, '0'),
                          style: cupertinoTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text(":", style: cupertinoTextStyle),
            Flexible(
              flex: 2,
              child: CupertinoPicker.builder(
                itemExtent: 36,
                offAxisFraction: 0.75,
                onSelectedItemChanged: (value) {
                  meetingNotifier.updateStartTime(
                      DateTimeExt(meetingController.start)
                          .copyWith(minute: value * 20));
                },
                childCount: 3,
                scrollController: FixedExtentScrollController(
                  initialItem: meeting == null
                      ? 0
                      : (meeting!.start.minute / 20).round(),
                ),
                itemBuilder: (context, index) => Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text(
                      (index * 20).toString().padLeft(2, '0'),
                      style: cupertinoTextStyle,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(child: Container()),
          ],
        ),
      ),
    );
  }
}
