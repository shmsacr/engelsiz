import 'package:engelsiz/controller/calendar_controller.dart';
import 'package:engelsiz/data/models/meeting_model.dart';
import 'package:engelsiz/ui/screens/calendar/app_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

extension DurationDivision on Duration {
  double operator /(Duration other) => inMicroseconds / other.inMicroseconds;
}

class AppointmentView extends ConsumerWidget {
  final Meeting? meeting;

  const AppointmentView({
    this.meeting,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meetingController = ref.watch(meetingProvider(meeting));
    final meetingNotifier = ref.watch(meetingProvider(meeting).notifier);
    final eventsController = ref.watch(eventsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toplantı"),
        elevation: 24.0,
        // backgroundColor: appointmentNotifier.appointment.color,
        backgroundColor: meetingController.appColor.color,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (meeting != null) {
                debugPrint("Update case");
                eventsController.appointments!.remove(meeting);
                eventsController.notifyListeners(
                    CalendarDataSourceAction.remove, <Meeting>[meeting!]);
              }
              eventsController.appointments?.add(meetingController);
              // SchedulerBinding.instance.addPostFrameCallback((_) {
              eventsController.notifyListeners(
                  CalendarDataSourceAction.add, <Meeting>[meetingController]);
              // });

              // debugPrint(meetingController.toString());
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
              controller: meetingNotifier.subjectTextController,

              // onChanged: (val) =>
              //     _debounce(() => meetingNotifier.updateSubject(val)),
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
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                  onPressed: () async {
                    DateTime? selection = await showDatePicker(
                      context: context,
                      initialDate: meetingController.start,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (selection != null) {
                      meetingNotifier.updateStartTime(selection);
                    }
                  },
                  child: Text(
                    DateFormat("EEE, MMM dd yyyy", "tr_TR")
                        .format(meetingController.start),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      enableDrag: true,
                      builder: (_) => AppTimePicker(meeting: meeting),
                    );
                  },
                  child: Text(
                      "${DateFormat("Hm").format(meetingController.start)} - ${DateFormat("Hm").format(meetingController.start.add(const Duration(minutes: 20)))}"),
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
                              meetingNotifier.updateColor(appColor);
                              Navigator.of(context).pop();
                            },
                            child: colorRow(appColor),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              child: colorRow(AppointmentColor.values
                  .firstWhere((e) => e == meetingController.appColor)),
            ),
          ),
          customDivider(),
          ListTile(
            leading: const Icon(Icons.subject),
            title: TextField(
              controller: meetingNotifier.notesTextController,
              // onChanged: (val) =>
              //     _debounce(() => meetingNotifier.updateNotes(val)),
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
