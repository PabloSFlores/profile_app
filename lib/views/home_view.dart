import 'package:flutter/material.dart';
import 'package:profile_app/viewmodels/auth_viewmodel.dart';
import 'package:profile_app/views/dashboard_view.dart';
import 'package:profile_app/views/user/profile_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variable para controlar el índice seleccionado del BottomNavigationBar
  int _selectedIndex = 0;

  // Lista de widgets que se mostrarán en función del índice seleccionado
  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardView(), // Vista del dashboard
    ProfileScreen(), // Vista del perfil
  ];

  // Método para cambiar el índice seleccionado
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
        actions: [
          IconButton(
            onPressed: () async {
              await authViewModel.logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
