import 'package:cloud_functions/cloud_functions.dart';
import 'package:engelsiz/controller/auth_controller.dart';
import 'package:engelsiz/ui/screens/login/login_screen.dart';
import 'package:engelsiz/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: AppColors.error),
        onPressed: () async {
          await _revokeToken();
          ref
              .read(firebaseAuthProvider)
              .signOut()
              .then((_) => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  ))
              .onError((error, stackTrace) => debugPrint(error.toString()));
          ref.read(tokenProvider.notifier).update((state) => null);
        },
        child: const Text("Çıkış Yap"),
      ),
    );
  }
}

Future<void> _revokeToken() async {
  try {
    await FirebaseFunctions.instance
        .httpsCallable('ext-auth-chat-revokeStreamUserToken')
        .call();
    debugPrint('Stream user token revoked');
  } on FirebaseFunctionsException catch (error) {
    debugPrint(error.code);
    debugPrint(error.details);
    debugPrint(error.message);
  }
}
