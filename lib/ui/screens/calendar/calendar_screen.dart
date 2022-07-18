import 'package:engelsiz/controller/calendar_controller.dart';
import 'package:engelsiz/ui/screens/calendar/appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final calendarFormat = ref.watch(CalendarController.format);
    // final selectedDay_ = ref.watch(CalendarController.selectedDay);
    final eventsController = ref.watch(eventsProvider);
    final calendarController = ref.watch(calendarProvider);
    return Scaffold(
      body: SfCalendar(
        controller: calendarController,
        view: CalendarView.month,
        firstDayOfWeek: 1,
        showNavigationArrow: true,
        showDatePickerButton: true,
        allowDragAndDrop: true,
        allowedViews: const [
          CalendarView.month,
          CalendarView.week,
          CalendarView.timelineWeek
        ],
        dataSource: eventsController,
        onTap: ((calendarTapDetails) {
          debugPrint(calendarTapDetails.date.toString());
        }),
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          showAgenda: true,
          showTrailingAndLeadingDates: true,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppointmentView(
                startTime: DateTime.now(),
              ),
            ),
          );
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
