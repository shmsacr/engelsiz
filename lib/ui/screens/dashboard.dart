import 'package:engelsiz/controller/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({
    Key? key,
  }) : super(key: key);

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _screens = <Widget>[
    HomeScreen(),
    CalendarScreen(),
    ProgressScreen(),
    MessageScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(dashboardIndexProvider);
    return Scaffold(
      body: _screens.elementAt(index),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'AnaSayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range, color: Colors.black),
            label: 'Takvim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dynamic_feed, color: Colors.black),
            label: 'Gelisim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded, color: Colors.black),
            label: 'Mesaj',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp, color: Colors.black),
            label: 'Profil',
          ),
        ],
        currentIndex: index,
        selectedItemColor: Colors.black,
        onTap: (int newIndex) => ref
            .read(dashboardIndexProvider.notifier)
            .update((state) => newIndex),
      ),
    );
  }
}
