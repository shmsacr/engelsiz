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
        firstDayOfWeek: 1,
        showNavigationArrow: true,
        dataSource: eventsController,
        view: CalendarView.month,
        allowedViews: const [CalendarView.month, CalendarView.week],
        timeSlotViewSettings: const TimeSlotViewSettings(timeFormat: 'HH:mm'),
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          showAgenda: true,
        ),
        onTap: (calendarTapDetails) {
          debugPrint(calendarTapDetails.date.toString());
        },
      ),
      floatingActionButton: ref.watch(isSelectedBeforeTodayProvider)
          ? null
          : FloatingActionButton(
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentView(
                      selectedTime: calendarController.selectedDate!,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
