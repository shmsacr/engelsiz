import 'package:engelsiz/controller/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentView extends ConsumerWidget {
  final DateTime startTime;

  const AppointmentView({
    required this.startTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentController =
        ref.watch(singleAppointmentProvider(startTime));
    final eventsController = ref.watch(eventsProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 24.0,
        backgroundColor: appointmentController.appointment.color,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              eventsController.appointments
                  ?.add(appointmentController.appointment);
              SchedulerBinding.instance.addPostFrameCallback((_) {
                eventsController.notifyListeners(CalendarDataSourceAction.add,
                    <Appointment>[appointmentController.appointment]);
              });
              Navigator.of(context).pop();
            },
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: appointmentController.subjectController,
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Konu Ekle',
              ),
            ),
          ),
          customDivider(),
          labeledCard(
            label: "Başlangıç",
            child: Row(
              children: [
                TextButton(
                    child: Text(
                      DateFormat("EEE, MMM dd yyyy")
                          .format(appointmentController.appointment.startTime),
                    ),
                    onPressed: () async {
                      DateTime? selection = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (selection != null) {
                        appointmentController.updateStartTime(selection);
                      }
                    }),
                TextButton(
                  child: Text(DateFormat("Hm")
                      .format(appointmentController.appointment.startTime)),
                  onPressed: () async {
                    final TimeOfDay? selection = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          appointmentController.appointment.startTime),
                    );
                    if (selection != null) {
                      final DateTime date =
                          appointmentController.appointment.startTime;
                      appointmentController.updateStartTime(
                        DateTime(date.year, date.month, date.day,
                            selection.hour, selection.minute),
                      );
                    }
                  },
                )
              ],
            ),
          ),
          labeledCard(
            label: "Bitiş",
            child: Row(
              children: [
                TextButton(
                    child: Text(
                      DateFormat("EEE, MMM dd yyyy")
                          .format(appointmentController.appointment.endTime),
                    ),
                    onPressed: () async {
                      DateTime? selection = await showDatePicker(
                        context: context,
                        initialDate: appointmentController.appointment.endTime,
                        firstDate: appointmentController.appointment.startTime,
                        lastDate: DateTime(2100),
                      );
                      if (selection != null) {
                        appointmentController.updateEndTime(selection);
                      }
                    }),
                TextButton(
                  child: Text(DateFormat("Hm")
                      .format(appointmentController.appointment.endTime)),
                  onPressed: () async {
                    final TimeOfDay? selection = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          appointmentController.appointment.endTime),
                    );
                    if (selection != null) {
                      final DateTime date =
                          appointmentController.appointment.endTime;
                      appointmentController.updateEndTime(
                        DateTime(date.year, date.month, date.day,
                            selection.hour, selection.minute),
                      );
                    }
                  },
                )
              ],
            ),
          ),
          customDivider(),
          labeledCard(
            label: "Renk",
            child: InkWell(
              onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Renk Seçin'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: AppointmentColor.values
                        .map(
                          (appColor) => InkWell(
                            borderRadius: BorderRadius.circular(8.0),
                            onTap: () {
                              appointmentController.updateColor(appColor.color);
                              Navigator.of(context).pop();
                            },
                            child: colorRow(appColor),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              child: colorRow(AppointmentColor.values.firstWhere(
                  (e) => e.color == appointmentController.appointment.color)),
            ),
          ),
          customDivider(),
          ListTile(
            leading: const Icon(Icons.subject),
            title: TextField(
              controller: appointmentController.descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: null,
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: "Açıklama Ekle...",
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget labeledCard({String label = "", required Widget child}) => Card(
      elevation: 1.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(label, textAlign: TextAlign.start),
            ),
          ),
          Expanded(flex: 2, child: child),
        ],
      ),
    );

Widget colorRow(AppointmentColor appColor) => Row(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          height: 30,
          width: 30,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: appColor.color),
        ),
        Text(appColor.name)
      ],
    );

Widget customDivider() => Column(
      children: const [
        SizedBox(height: 8.0),
        Divider(height: 1.0, thickness: 1),
        SizedBox(height: 8.0),
      ],
    );
