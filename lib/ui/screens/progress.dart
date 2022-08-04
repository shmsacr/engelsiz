import 'package:engelsiz/controller/db_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataProvider = StateProvider<String>((ref) => "initial");

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(dbProvider);
    return Center(
      child: TextButton(
        onPressed: () async {
          final userAdditional = await db.sa();
          ref
              .read(dataProvider.notifier)
              .update((state) => userAdditional.toString());
        },
        child: Text(ref.watch(dataProvider)),
      ),
    );
  }
}
