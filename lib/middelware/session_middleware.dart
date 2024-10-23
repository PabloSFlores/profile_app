import 'package:flutter/material.dart';
import 'package:profile_app/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class SessionMiddleware extends StatelessWidget {
  final Widget protectedScreen;

  const SessionMiddleware({super.key, required this.protectedScreen});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    // Ejecutar la lógica de sesión después de que se haya construido el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authViewModel.checkSession().then((_) {
        if (authViewModel.user == null) {
          Navigator.popAndPushNamed(context, '/login');
        }
      });
    });

    return protectedScreen;
  }
}

