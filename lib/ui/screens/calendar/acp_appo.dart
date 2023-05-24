import 'package:engelsiz/data/models/appointment_with_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    margin: const EdgeInsets.all(50),
                    child: Row(
                      children: [
                        Avatar.large(
                          url: data["profilePicture"],
                        ),
                        Text(
                          data['fullName'],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
        error: (error, _) => Text(error.toString()),
        loading: () => CircularProgressIndicator());
  }
}
