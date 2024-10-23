import 'package:flutter/material.dart';
import 'package:profile_app/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';

// profile_screen.dart
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    // Llamar a la función para cargar los datos del perfil
    authViewModel.fetchUserProfile().then((_) {
      _nameController = TextEditingController(text: authViewModel.user?.name);
      _emailController = TextEditingController(text: authViewModel.user?.email);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    if (authViewModel.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authViewModel.updateUserProfile(
                  _nameController.text,
                  _emailController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Perfil actualizado correctamente')),
                );
              },
              child: Text('Actualizar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}
