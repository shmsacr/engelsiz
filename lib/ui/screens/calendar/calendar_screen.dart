import 'package:engelsiz/controller/calendar_controller.dart';
import 'package:engelsiz/data/models/meeting_model.dart';
import 'package:engelsiz/ui/screens/calendar/appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsController = ref.watch(eventsProvider);
    final calendarController = ref.watch(calendarProvider);
    return Scaffold(
        body: SfCalendar(
          controller: calendarController,
          firstDayOfWeek: 1,
          showNavigationArrow: true,
          timeZone: 'Turkey Standard Time',
          dataSource: eventsController,
          view: CalendarView.month,
          allowedViews: const [CalendarView.month, CalendarView.week],
          timeSlotViewSettings: const TimeSlotViewSettings(timeFormat: 'HH:mm'),
          cellEndPadding: 0,
          appointmentTimeTextFormat: 'HH:mm',
          monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            showAgenda: true,
          ),
          onTap: (calendarTapDetails) {
            if (calendarTapDetails.targetElement ==
                CalendarElement.appointment) {
              debugPrint(calendarTapDetails.targetElement.toString());
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    Meeting meeting =
                        calendarTapDetails.appointments![0] as Meeting;
                    return AppointmentView(meeting: meeting);
                  },
                ),
              );
            }
          },
        ),
        floatingActionButton: !ref.watch(isSelectedBeforeTodayProvider) &&
                ref.watch(isSelectedInWorkingHours)
            ? FloatingActionButton(
                shape: const CircleBorder(),
                child: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppointmentView(),
                    ),
                  );
                },
              )
            : null);
  }
}
