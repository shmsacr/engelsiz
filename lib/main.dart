import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // static const List<Widget> _widgetOptions = <Widget>[
  //   Text(
  //     'Index 0: Anasayfa',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Index 1: Takvim',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Index 2: Gelisim',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Index 3: Mesaj',
  //     style: optionStyle,
  //   ),
  //   Text(
  //     'Index 4: Profil',
  //     style: optionStyle,
  //   ),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home,color: Colors.black),
          label: 'AnaSayfa',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.date_range,color: Colors.black),
          label: 'Takvim',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dynamic_feed,color: Colors.black),
          label: 'Gelisim',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_rounded,color: Colors.black),
          label: 'Mesaj',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_sharp,color: Colors.black),
          label: 'Profil',
        ),

      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black,
      onTap: _onItemTapped,
    );
  }
}
