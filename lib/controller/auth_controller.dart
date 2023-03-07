import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    as stream_chat;

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final fireStoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final firebaseFunctionsProvider = Provider<FirebaseFunctions>(
    (ref) => FirebaseFunctions.instanceFor(region: "us-central1"));

final userChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(firebaseAuthProvider).userChanges());

final tokenProvider = StateProvider<String?>((ref) => null);

final streamTokenProvider = FutureProvider.autoDispose<void>((ref) async {
  final User? currentUser =
      ref.watch(firebaseAuthProvider.select((value) => value.currentUser));
  if (currentUser != null) {
    final token = await getStreamToken(ref);
    await ref
        .watch(clientProvider)
        .connectUser(stream_chat.User(id: currentUser.uid), token!);
  } else {
    ref.read(tokenProvider.notifier).update((state) => null);
  }
});

const streamKey = 't22mrgu47yyc';

final clientProvider = Provider<stream_chat.StreamChatClient>(
    (ref) => stream_chat.StreamChatClient(streamKey));

Future<String?> getStreamToken(ref) async {
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
    return result.data.toString();
  } on FirebaseFunctionsException catch (error) {
    debugPrint(error.code);
    debugPrint(error.details);
    debugPrint(error.message);
  }
  return null;
}
