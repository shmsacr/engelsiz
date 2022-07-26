import 'package:engelsiz/ui/screens/login/login_screen.dart';
import 'package:engelsiz/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:engelsiz/controller/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: AppColors.error),
        onPressed: () => ref
            .read(firebaseAuthProvider)
            .signOut()
            .then((_) => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false))
            .onError((error, stackTrace) => debugPrint(error.toString())),
        child: const Text("Çıkış Yap"),
      ),
    );
  }
}
