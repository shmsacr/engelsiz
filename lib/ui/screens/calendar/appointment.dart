import 'package:engelsiz/controller/calendar_controller.dart';
import 'package:engelsiz/utils/datetime_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentView extends ConsumerWidget {
  final DateTime selectedTime;

  const AppointmentView({
    required this.selectedTime,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentController =
        ref.watch(singleAppointmentProvider(selectedTime));
    final eventsController = ref.watch(eventsProvider);
    final cupertinoTextStyle = Theme.of(context).textTheme.headlineSmall;
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
                hintText: 'Konu Ekle...',
              ),
            ),
          ),
          customDivider(),
          labeledCard(
            label: "Zaman",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    child: Text(
                      DateFormat("EEE, MMM dd yyyy", "tr_TR")
                          .format(appointmentController.appointment.startTime),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    onPressed: () async {
                      DateTime? selection = await showDatePicker(
                        context: context,
                        initialDate: selectedTime,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (selection != null) {
                        appointmentController.updateStartTime(selection);
                      }
                    }),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                  onPressed: () async {
                    _showDialog(
                      context,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(child: Container()),
                          Flexible(
                            flex: 2,
                            child: CupertinoPicker(
                              itemExtent: 36,
                              scrollController:
                                  FixedExtentScrollController(initialItem: 1),
                              onSelectedItemChanged: (value) {
                                appointmentController.updateStartTime(
                                    DateTimeExt(appointmentController
                                            .appointment.startTime)
                                        .copyWith(hour: value + 8));
                              },
                              children: List<Widget>.generate(
                                10,
                                (int index) => Material(
                                  type: MaterialType.transparency,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 24.0),
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
                            child: CupertinoPicker(
                              offAxisFraction: 0.75,
                              itemExtent: 36,
                              onSelectedItemChanged: (value) {
                                debugPrint((value * 20).toString());
                                appointmentController.updateStartTime(
                                    DateTimeExt(appointmentController
                                            .appointment.startTime)
                                        .copyWith(minute: value * 20));
                              },
                              children: List<Widget>.generate(
                                3,
                                (int index) => Align(
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
                          ),
                          Flexible(child: Container()),
                        ],
                      ),
                    );
                  },
                  child: Text(
                      "${DateFormat("Hm").format(appointmentController.appointment.startTime)} - ${DateFormat("Hm").format(appointmentController.appointment.startTime.add(const Duration(minutes: 20)))}"),
                )
              ],
            ),
          ),
          // labeledCard(
          //   label: "Bitiş",
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       Text(DateFormat("EEE, MMM dd yyyy")
          //           .format(appointmentController.appointment.endTime)),
          //       Text(DateFormat("Hm")
          //           .format(appointmentController.appointment.endTime)),
          //     ],
          //   ),
          // Row(
          //   children: [
          //     TextButton(
          //       child: Text(
          //         DateFormat("EEE, MMM dd yyyy")
          //             .format(appointmentController.appointment.endTime),
          //       ),
          //       onPressed: () {},
          //     ),
          //
          //     // TextButton(
          //     //   child: Text(DateFormat("Hm")
          //     //       .format(appointmentController.appointment.endTime)),
          //     //   onPressed: () async {
          //     //     // final TimeOfDay? selection = await showTimePicker(
          //     //     //   context: context,
          //     //     //   initialTime: TimeOfDay.fromDateTime(
          //     //     //     appointmentController.appointment.endTime,
          //     //     //   ),
          //     //     // );
          //     //     // if (selection != null) {
          //     //     //   final DateTime date =
          //     //     //       appointmentController.appointment.endTime;
          //     //     //   appointmentController.updateEndTime(
          //     //     //     DateTime(date.year, date.month, date.day,
          //     //     //         selection.hour, selection.minute),
          //     //     //   );
          //     //     // }
          //     //   },
          //     // )
          //   ],
          // ),
          // ),
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

void _showDialog(BuildContext context, Widget child) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => Container(
      height: 216,
      // padding: const EdgeInsets.only(top: 6.0),
      // The Bottom margin is provided to align the popup above the system navigation bar.
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      // Provide a background color for the popup.
      color: CupertinoColors.systemBackground.resolveFrom(context),
      // Use a SafeArea widget to avoid system overlaps.
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: child,
        ),
      ),
    ),
  );
}

Widget labeledCard({String label = "", required Widget child}) => Card(
      elevation: 1.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(height: 52),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(label, textAlign: TextAlign.start),
              ),
            ),
            Expanded(flex: 5, child: child),
          ],
        ),
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
