import 'package:engelsiz/utils/datetime_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

final eventsProvider = Provider<MeetingDataSource>(
    (ref) => MeetingDataSource(List.empty(growable: true)));

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

class AppointmentNotifier extends ChangeNotifier {
  final Appointment appointment;
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  AppointmentNotifier({required DateTime startTime, DateTime? endTime})
      : appointment = Appointment(
          startTime: startTime,
          endTime: endTime ?? startTime.add(const Duration(minutes: 20)),
          color: AppointmentColor.green.color,
        ) {
    subjectController.addListener(_updateSubject);
    descriptionController.addListener(_updateDescription);
  }

  int? get startHour => appointment.startTime.hour;
  int? get startMinute => appointment.startTime.minute;

  void updateStartTime(DateTime startTime) {
    final startTime_ = preventMidnight(startTime);
    appointment.startTime = startTime_;
    appointment.endTime = startTime_.add(const Duration(minutes: 20));
    notifyListeners();
  }

  void updateEndTime(DateTime endTime) {
    appointment.endTime = endTime;
    notifyListeners();
  }

  void updateColor(Color color) {
    appointment.color = color;
    notifyListeners();
  }

  void _updateSubject() {
    appointment.subject = subjectController.text;
    notifyListeners();
  }

  void _updateDescription() {
    appointment.notes = descriptionController.text;
    notifyListeners();
  }
}

final singleAppointmentProvider =
    ChangeNotifierProvider.family<AppointmentNotifier, DateTime>(
        (ref, startTime) {
  return AppointmentNotifier(startTime: preventMidnight(startTime));
});

DateTime preventMidnight(DateTime time) =>
    time.hour == 0 ? time.add(const Duration(hours: 9)) : time;

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
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  String getStartTimeZone(int index) {
    return appointments![index].startTimeZone;
  }

  @override
  String getEndTimeZone(int index) {
    return appointments![index].endTimeZone;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
