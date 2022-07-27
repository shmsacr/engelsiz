import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final userChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(firebaseAuthProvider).userChanges());

final userProvider = Provider<User?>((ref) {
  ref.watch(userChangesProvider);
  return ref.watch(firebaseAuthProvider.select((value) => value.currentUser));
});
