import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final firebaseFunctionsProvider = Provider<FirebaseFunctions>(
    (ref) => FirebaseFunctions.instanceFor(region: "us-central1"));

final userChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(firebaseAuthProvider).userChanges());

final tokenProvider = StateProvider<String?>((ref) => null);

final streamTokenProvider = FutureProvider.autoDispose<void>((ref) async {
  if (ref.watch(firebaseAuthProvider.select((value) => value.currentUser)) !=
      null) {
    await getStreamToken(ref);
  } else {
    ref.read(tokenProvider.notifier).update((state) => null);
  }
});

Future<void> getStreamToken(ref) async {
  if (ref is! WidgetRef && ref is! Ref) {
    throw Exception("Please supply a valid argument for 'ref'");
  }
  try {
    final result = await ref
        .read(firebaseFunctionsProvider)
        .httpsCallable('ext-auth-chat-getStreamUserToken')
        .call();
    debugPrint('Stream user token retrieved: ${result.data}');
    ref.read(tokenProvider.notifier).update((state) => result.data.toString());
  } on FirebaseFunctionsException catch (error) {
    debugPrint(error.code);
    debugPrint(error.details);
    debugPrint(error.message);
  }
}
