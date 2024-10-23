import 'package:flutter/material.dart';

class ButtonNavigationBarWidget extends StatefulWidget {
  const ButtonNavigationBarWidget({super.key});

  @override
  State<ButtonNavigationBarWidget> createState() =>
      _ButtonNavigationBarWidgetState();
}

class _ButtonNavigationBarWidgetState extends State<ButtonNavigationBarWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  final List<Widget> _widgetOptions = <Widget>[
    Text(
      'Inicio',
      style: optionStyle,
    ),
    Text(
      'Perfil',
      style: optionStyle,
    )
  ];

  Widget get selectedWidget => _widgetOptions.elementAt(_selectedIndex);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil')
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
