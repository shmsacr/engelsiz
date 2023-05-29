import 'package:engelsiz/data/models/appointment_with_id.dart';
import 'package:engelsiz/ui/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../controller/appointment_controller.dart';
import '../Message/avatar.dart';

class AcceptAppointment extends ConsumerWidget {
  const AcceptAppointment({Key? key, required this.appointmentWithId})
      : super(key: key);
  final AppointmentWithId appointmentWithId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAcpt =
        ref.watch(contactUserAppo(appointmentWithId.appointment.parentId));
    return userAcpt.when(
        data: (data) => Scaffold(
              appBar: AppBar(
                title: Text("Randevu Kabul"),
              ),
              body: Column(
                children: [
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 60, left: 20, right: 20),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Card(
                          color: Colors.blueGrey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Avatar.large(
                                      url: data["profilePicture"],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03),
                                      child: Text(
                                        data['fullName'],
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: EdgeInsets.only(
                                    //       right: MediaQuery.of(context).size.height *
                                    //           0.15,
                                    //       top: MediaQuery.of(context).size.height *
                                    //           0.03),
                                    //   child:
                                    //       Text(appointmentWithId.appointment.title),
                                    // )
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "${DateFormat("yyyy-MM-dd").format(appointmentWithId.appointment.start)}",
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "${DateFormat("Hm").format(appointmentWithId.appointment.start)} - ${DateFormat("Hm").format(appointmentWithId.appointment.end)}",
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            appointmentWithId.appointment.title,
                                            style: const TextStyle(
                                                color: Colors.black87,
                                                fontFamily: "Montserrat",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                            softWrap: false,
                                            maxLines: 9,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          // Expanded(
                                          //   child: Text(
                                          //     appointmentWithId.appointment.title,
                                          //     style: const TextStyle(
                                          //       color: Colors.black87,
                                          //       fontFamily: "Montserrat",
                                          //       fontWeight: FontWeight.w500,
                                          //     ),
                                          //     softWrap: false,
                                          //     maxLines: 1,
                                          //     overflow: TextOverflow.ellipsis,
                                          //   ),
                                          // ),
                                          Text(
                                            appointmentWithId.appointment.notes,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontFamily: "Montserrat",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                            softWrap: false,
                                            maxLines: 9,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.09),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterialButton(
                              color: Colors.redAccent,
                              onPressed: () async {
                                try {
                                  await deleteAppointment(
                                      appointmentWithId, ref);
                                  if (context.mounted) {
                                    Navigator.pop(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DashboardScreen()));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Randevu reddedildi")),
                                    );
                                  }
                                } catch (e) {
                                  debugPrint(e.toString());
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("$e")));
                                }
                              },
                              child: const Text(
                                "Reddet",
                              ),
                            ),
                            MaterialButton(
                              color: Colors.greenAccent,
                              onPressed: () async {
                                try {
                                  await updateAppointment(
                                      appointmentWithId.id, ref);
                                  if (context.mounted) {
                                    Navigator.pop(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DashboardScreen()));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Randevu onaylandı")),
                                    );
                                  }
                                } catch (e) {
                                  debugPrint(e.toString());
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("$e")));
                                }
                              },
                              child: const Text(
                                "Kabul et",
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
        error: (error, _) => Text(error.toString()),
        loading: () => CircularProgressIndicator());
  }
}
