import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:engelsiz/controller/dashboard_controller.dart';
import 'package:engelsiz/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens.dart';

class DashboardScreen extends ConsumerWidget {
  static Route get route =>
      MaterialPageRoute(builder: (context) => DashboardScreen());
  const DashboardScreen({
    Key? key,
  }) : super(key: key);

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final List<Widget> _screens = const <Widget>[
    HomeScreen(),
    CalendarScreen(),
    Progress(),
    MessageScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(dashboardIndexProvider);
    return Scaffold(
      body: SafeArea(child: _screens.elementAt(index)),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // todo: baglantı sayfası
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: GlowingActionButton(
          //     color: AppColors.secondary,
          //     icon: Icons.add,
          //     onPressed: () {
          //       showDialog(
          //         context: context,
          //         builder: (BuildContext context) => Dialog(
          //           child: AspectRatio(
          //             aspectRatio: 8 / 7,
          //             child: ContactsPage(),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
          CurvedNavigationBar(
            height: 44,
            items: const [
              Icon(Icons.home, color: AppColors.primaryContainer),
              Icon(Icons.date_range, color: AppColors.primaryContainer),
              Icon(Icons.dynamic_feed, color: AppColors.primaryContainer),
              Icon(Icons.chat_rounded, color: AppColors.primaryContainer),
              Icon(Icons.account_circle_sharp,
                  color: AppColors.primaryContainer),
            ],
            index: index,
            color: AppColors.primary,
            backgroundColor:
                MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? const Color(0xff101d28)
                    : const Color(0xffb7c6d8),
            onTap: (int newIndex) => ref
                .read(dashboardIndexProvider.notifier)
                .update((state) => newIndex),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 6.0).copyWith(left: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: labelList
                  .asMap()
                  .entries
                  .map((e) => e.key == index ? _label(e.value) : _label(""))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

const labelList = ["Ana Sayfa", "Randevu", "Gelişim", "Mesajlar", "Profil"];

Widget _label(String label) => Expanded(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: AppColors.primaryContainer),
        ),
      ),
    );
