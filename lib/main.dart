import 'package:flutter/material.dart';
import 'package:profile_app/middelware/session_middleware.dart';
import 'package:profile_app/viewmodels/auth_viewmodel.dart';
import 'package:profile_app/views/home_view.dart';
import 'package:profile_app/views/user/register_screen.dart';
import 'package:provider/provider.dart';
import 'views/user/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
      ],
      child: MaterialApp(
        title: 'App de Usuarios',
        routes: {
          '/home': (context) =>
              SessionMiddleware(protectedScreen: HomeScreen()),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen()
        },
        initialRoute: '/home',
      ),
    );
  }
}
