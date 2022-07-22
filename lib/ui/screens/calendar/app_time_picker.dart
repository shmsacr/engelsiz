import 'package:engelsiz/data/models/meeting_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:engelsiz/utils/datetime_ext.dart';

import 'package:engelsiz/controller/calendar_controller.dart';

class AppTimePicker extends ConsumerWidget {
  final Meeting? meeting;

  const AppTimePicker({this.meeting, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cupertinoTextStyle = Theme.of(context).textTheme.headlineSmall;
    final cupertinoTextStyleDisabled = Theme.of(context)
        .textTheme
        .headlineSmall
        ?.copyWith(color: Colors.red, decoration: TextDecoration.lineThrough);
    final meetingController = ref.watch(meetingProvider(meeting));
    final meetingNotifier = ref.watch(meetingProvider(meeting).notifier);

    final List<TimeOfDay> filledTimes = filledPeriods(
      ref.watch(eventsProvider),
      meetingController.start,
    );

    final FixedExtentScrollController hourController =
        FixedExtentScrollController(
            initialItem: (meetingController.start.hour - 8).round());
    final FixedExtentScrollController minuteController =
        FixedExtentScrollController(
            initialItem: (meetingController.start.minute / 20).round());

    _updateStartTime() {
      final selectedHour = hourController.selectedItem + 8;
      final selectedMinute = minuteController.selectedItem * 20;
      List<int> validMinutes = selectValidMinutesOfAHour(
          filledTimes, selectedHour, meeting?.start.minute);
      List<int> validHours = selectValidHoursOfAMinute(
          filledTimes, selectedMinute, meeting?.start.hour);
      if (validHours.contains(selectedHour) &&
          validMinutes.contains(selectedMinute)) {
        meetingNotifier.updateStartTime(DateTimeExt(meetingController.start)
            .copyWith(hour: selectedHour, minute: selectedMinute));
      }
    }

    hourController.addListener(_updateStartTime);
    minuteController.addListener(_updateStartTime);
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
              child: CupertinoPicker.builder(
                itemExtent: 36,
                scrollController: hourController,
                onSelectedItemChanged: (_) {},
                childCount: 10,
                itemBuilder: (_, index) => Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Text(
                      (index + 8).toString().padLeft(2, '0'),
                      style: selectValidHoursOfAMinute(
                        filledTimes,
                        preventNonSelectedException(
                            minuteController, meetingController.start.minute),
                        meeting?.start.hour,
                      ).contains(index + 8)
                          ? cupertinoTextStyle
                          : cupertinoTextStyleDisabled,
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
                scrollController: minuteController,
                onSelectedItemChanged: (_) {},
                childCount: 3,
                itemBuilder: (context, index) => Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text((index * 20).toString().padLeft(2, '0'),
                        style: selectValidMinutesOfAHour(
                          filledTimes,
                          hourController.selectedItem + 8,
                          meeting?.start.minute,
                        ).contains(index * 20)
                            ? cupertinoTextStyle
                            : cupertinoTextStyleDisabled),
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

List<int> selectValidMinutesOfAHour(
    List<TimeOfDay> filledTimes, int hour, int? oldMeetingMinute) {
  final List<int> filledMinutes = filledTimes
      .where((time) => time.hour == hour)
      .map<int>((time) => time.minute)
      .toList();
  if (oldMeetingMinute != null) {
    filledMinutes.remove(oldMeetingMinute);
  }
  return [0, 20, 40].where((m) => !filledMinutes.contains(m)).toList();
}

List<int> selectValidHoursOfAMinute(
    List<TimeOfDay> filledTimes, int minute, int? oldMeetingHour) {
  final List<int> filledHours = filledTimes
      .where((time) => time.minute == minute)
      .map<int>((time) => time.hour)
      .toList();
  if (oldMeetingHour != null) {
    filledHours.remove(oldMeetingHour);
  }
  return List.generate(10, (i) => i + 8)
      .where((m) => !filledHours.contains(m))
      .toList();
}

int preventNonSelectedException(
    FixedExtentScrollController minuteController, int minute) {
  try {
    return minuteController.selectedItem * 20;
  } catch (error) {
    return minute;
  }
}
