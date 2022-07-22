import 'package:engelsiz/data/models/meeting_model.dart';
import 'package:engelsiz/ui/screens/calendar/appointment.dart';
import 'package:engelsiz/utils/datetime_ext.dart';
import 'package:engelsiz/utils/debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

final eventsProvider = Provider<MeetingDataSource>(
    (ref) => MeetingDataSource(List<Meeting>.empty(growable: true)));

final calendarProvider = Provider<CalendarController>((ref) {
  final calendarController = CalendarController();
  DateTime today = DateTimeExt(DateTime.now())
      .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  calendarController.selectedDate = today;
  calendarController.displayDate = today;
  calendarController.addPropertyChangedListener(
    (property) {
      if (property == "selectedDate" &&
          calendarController.selectedDate != null) {
        ref.read(isSelectedBeforeTodayProvider.notifier).update(
            (state) => calendarController.selectedDate!.isBefore(today));
      }
    },
  );
  return calendarController;
});

final isSelectedBeforeTodayProvider = StateProvider<bool>((ref) => false);

class MeetingNotifier extends StateNotifier<Meeting> {
  MeetingNotifier(Meeting meeting) : super(meeting) {
    subjectTextController.text = meeting.subject;
    subjectTextController.addListener(() => _debounce(_updateSubject));
    notesTextController.text = meeting.notes;
    notesTextController.addListener(() => _debounce(_updateNotes));
  }

  final Debounce _debounce = Debounce();
  final TextEditingController subjectTextController = TextEditingController();
  final TextEditingController notesTextController = TextEditingController();

  void updateStartTime(DateTime startTime) {
    state = state.copyWith(
        start: startTime, end: startTime.add(const Duration(minutes: 20)));
  }

  void updateEndTime(DateTime endTime) {
    state = state.copyWith(end: endTime);
  }

  void updateColor(AppointmentColor appColor) {
    state = state.copyWith(appColor: appColor);
  }

  void _updateSubject() {
    state = state.copyWith(subject: subjectTextController.text);
  }

  void _updateNotes() {
    state = state.copyWith(notes: notesTextController.text);
  }
}

final meetingProvider = StateNotifierProvider.family
    .autoDispose<MeetingNotifier, Meeting, Meeting?>((ref, meeting) {
  if (meeting != null) return MeetingNotifier(meeting);
  DateTime startTime =
      midnightToEightAM(ref.watch(calendarProvider).selectedDate!);
  final List<TimeOfDay> filledPeriods_ = filledPeriods(
    ref.watch(eventsProvider),
    ref.watch(calendarProvider).selectedDate!,
  );
  while (filledPeriods_.contains(TimeOfDay.fromDateTime(startTime))) {
    startTime = startTime.add(const Duration(minutes: 20));
  }
  return MeetingNotifier(
    Meeting(start: startTime, end: startTime.add(const Duration(minutes: 20))),
  );
});

enum AppointmentColor {
  green(Color.fromRGBO(15, 134, 68, 1), "Yeşil"),
  purple(Color.fromRGBO(139, 31, 169, 1), "Mor"),
  red(Color.fromRGBO(210, 1, 0, 1), "Kırmızı"),
  orange(Color.fromRGBO(252, 87, 29, 1), "Turuncu"),
  caramel(Color.fromRGBO(133, 70, 30, 1), "Karamel"),
  lightGreen(Color.fromRGBO(54, 179, 123, 1), "Açık Yeşil"),
  blue(Color.fromRGBO(61, 79, 181, 1), "Mavi"),
  peach(Color.fromRGBO(228, 124, 115, 1), "Şeftali"),
  grey(Color.fromRGBO(99, 99, 99, 1), "Gri");

  const AppointmentColor(this.color, this.name);
  final Color color;
  final String name;
}

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].start;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].end;
  }

  // @override
  // bool isAllDay(int index) {
  //   return appointments![index].isAllDay;
  // }

  @override
  String getSubject(int index) {
    return appointments![index].subject;
  }

  @override
  String getNotes(int index) {
    return appointments![index].notes;
  }

  // @override
  // String getStartTimeZone(int index) {
  //   return appointments![index].startTimeZone;
  // }
  //
  // @override
  // String getEndTimeZone(int index) {
  //   return appointments![index].endTimeZone;
  // }

  @override
  Color getColor(int index) {
    return appointments![index].appColor.color;
  }
}

DateTime midnightToEightAM(DateTime time) =>
    time.hour == 0 ? time.add(const Duration(hours: 8)) : time;

List<TimeOfDay> filledPeriods(
    MeetingDataSource eventsController, DateTime meetingStart) {
  /// Calculates which periods are already filled
  /// Returns their startTimes as TimeOfDay
  return eventsController
      .getVisibleAppointments(meetingStart, 'Turkey Standard Time')
      .map((m) => List.generate(
          (m.endTime.difference(m.startTime) / const Duration(minutes: 20))
              .ceil(),
          (i) => TimeOfDay.fromDateTime(
              m.startTime.add(Duration(minutes: i * 20)))))
      .expand((e) => e)
      .toList();
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
// @immutable
// class Meeting {
//   /// Creates a meeting class with required details.
//   const Meeting(
//       {this.eventName = '',
//       required this.from,
//       required this.to,
//       this.background = AppointmentColor.green,
//       this.isAllDay = false,
//       this.notes = ''});
//
//   /// Event name which is equivalent to subject property of [Appointment].
//   final String eventName;
//
//   /// From which is equivalent to start time property of [Appointment].
//   final DateTime from;
//
//   /// To which is equivalent to end time property of [Appointment].
//   final DateTime to;
//
//   /// Background which is equivalent to color property of [Appointment].
//   final AppointmentColor background;
//
//   /// IsAllDay which is equivalent to isAllDay property of [Appointment].
//   final bool isAllDay;
//
//   final String notes;
// }
