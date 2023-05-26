import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engelsiz/data/models/appointment_model.dart' as app;
import 'package:engelsiz/data/models/appointment_with_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_controller.dart';

Future<void> createAppointment(
    {required WidgetRef ref, required app.MyAppointment appointment}) async {
  final docRef = await ref
      .read(fireStoreProvider)
      .collection('appointments')
      .add(appointment.toJson());
  addAppointment(ref: ref, appointments: appointment, docId: docRef.id);
  debugPrint(docRef.id);
}

Future<void> addAppointment(
    {required WidgetRef ref,
    required app.MyAppointment appointments,
    required String docId}) async {
  await ref
      .read(fireStoreProvider)
      .collection("users")
      .doc(appointments.teacherId)
      .update({
    "waitAppo": FieldValue.arrayUnion([docId])
  });
  await ref
      .read(fireStoreProvider)
      .collection("users")
      .doc(appointments.parentId)
      .update({
    "waitAppo": FieldValue.arrayUnion([docId])
  });
}

final appointmentProvider = FutureProvider<dynamic>((ref) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  final snapShot = await ref
      .read(fireStoreProvider)
      .collection("users")
      .doc(auth.currentUser?.uid)
      .get();
  return snapShot.data()!["waitAppo"];
});

final getAppointmentsProvider =
    StreamProvider.autoDispose<List<AppointmentWithId>>((ref) {
  return ref
      .watch(fireStoreProvider)
      .collection("appointments")
      .where(FieldPath.documentId,
          whereIn: ref.watch(appointmentProvider).value)
      .snapshots()
      .map((querySnapshot) => querySnapshot.docs.map((doc) {
            return AppointmentWithId(
                id: doc.id,
                appointment: app.MyAppointment.fromJson(doc.data()));
          }).toList());
});

final contactUserAppo = FutureProvider.autoDispose
    .family<DocumentSnapshot, String>((ref, userId) async {
  final snapShot =
      await FirebaseFirestore.instance.collection("users").doc(userId).get();
  return snapShot;
});

updateAppointment(String appoId, WidgetRef ref) async {
  await ref
      .watch(fireStoreProvider)
      .collection("appointments")
      .doc(appoId)
      .update({"situation": true});
}

deleteAppointment(AppointmentWithId appoId, WidgetRef ref) async {
  await ref
      .watch(fireStoreProvider)
      .collection("appointments")
      .doc(appoId.id)
      .delete();
  await ref
      .watch(fireStoreProvider)
      .collection("users")
      .doc(appoId.appointment.teacherId)
      .update({
    "waitAppo": FieldValue.arrayRemove([appoId.id])
  });
  await ref
      .watch(fireStoreProvider)
      .collection("users")
      .doc(appoId.appointment.parentId)
      .update({
    "waitAppo": FieldValue.arrayRemove([appoId.id])
  });
}
