import 'package:engelsiz/controller/appointment_controller.dart';
import 'package:engelsiz/controller/calendar_controller.dart';
import 'package:engelsiz/ui/screens/calendar/acp_appo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../controller/auth_controller.dart';
import '../../../data/models/meeting_model.dart';
import 'appointment.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsController = ref.watch(eventsProvider);
    final calendarController = ref.watch(calendarProvider);
    final getAppointments = ref.watch(getAppointmentsProvider);
    return FutureBuilder<bool>(
      future: isMyTeacher(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Hata: ${snapshot.error}");
        } else {
          bool isTeacher = snapshot.data ?? false;
          return isTeacher
              ? getAppointments.when(
                  data: (data) => Scaffold(
                        appBar: AppBar(
                          title: const Center(child: Text("Randevular")),
                        ),
                        body: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            if (!data[index].appointment.situation) {
                              return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AcceptAppointment(
                                            appointmentWithId: data[index]),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: Column(
                                            children: [
                                              const SizedBox(
                                                height: 7,
                                              ),
                                              Text(
                                                  "${DateFormat("yyyy-MM-dd").format(data[index].appointment.start)}"),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  "${DateFormat("Hm").format(data[index].appointment.start)} - ${DateFormat("Hm").format(data[index].appointment.end)}"),
                                            ],
                                          ),
                                          title: Text(
                                              data[index].appointment.title),
                                          subtitle: Text(
                                              data[index].appointment.notes),
                                        )
                                      ],
                                    ),
                                  ));
                            } else
                              return SizedBox();
                          },
                        ),
                      ),
                  error: (error, _) => Text(error.toString()),
                  loading: () => CircularProgressIndicator())
              : Scaffold(
                  body: SfCalendar(
                    controller: calendarController,
                    firstDayOfWeek: 1,
                    showNavigationArrow: true,
                    timeZone: 'Turkey Standard Time',
                    dataSource: eventsController,
                    view: CalendarView.month,
                    allowedViews: const [CalendarView.month, CalendarView.week],
                    timeSlotViewSettings:
                        const TimeSlotViewSettings(timeFormat: 'HH:mm'),
                    cellEndPadding: 0,
                    appointmentTimeTextFormat: 'HH:mm',
                    monthViewSettings: const MonthViewSettings(
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.appointment,
                      showAgenda: true,
                    ),
                    onTap: (calendarTapDetails) {
                      if (calendarTapDetails.targetElement ==
                          CalendarElement.appointment) {
                        debugPrint(calendarTapDetails.targetElement.toString());
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              Meeting meeting = calendarTapDetails
                                  .appointments![0] as Meeting;
                              return AppointmentView(meeting: meeting);
                            },
                          ),
                        );
                      }
                    },
                  ),
                  floatingActionButton: !ref
                              .watch(isSelectedBeforeTodayProvider) &&
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
      },
    );
  }
}
// return Scaffold(
// body: SfCalendar(
// controller: calendarController,
// firstDayOfWeek: 1,
// showNavigationArrow: true,
// timeZone: 'Turkey Standard Time',
// dataSource: eventsController,
// view: CalendarView.month,
// allowedViews: const [CalendarView.month, CalendarView.week],
// timeSlotViewSettings:
// const TimeSlotViewSettings(timeFormat: 'HH:mm'),
// cellEndPadding: 0,
// appointmentTimeTextFormat: 'HH:mm',
// monthViewSettings: const MonthViewSettings(
// appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
// showAgenda: true,
// ),
// onTap: (calendarTapDetails) {
// if (calendarTapDetails.targetElement ==
// CalendarElement.appointment) {
// debugPrint(calendarTapDetails.targetElement.toString());
// Navigator.of(context).push(
// MaterialPageRoute(
// builder: (context) {
// Meeting meeting =
// calendarTapDetails.appointments![0] as Meeting;
// return AppointmentView(meeting: meeting);
// },
// ),
// );
// }
// },
// ),
// floatingActionButton: !ref.watch(isSelectedBeforeTodayProvider) &&
// ref.watch(isSelectedInWorkingHours)
// ? FloatingActionButton(
// shape: const CircleBorder(),
// child: const Icon(Icons.add),
// onPressed: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => const AppointmentView(),
// ),
// );
// },
// )
// : null);
