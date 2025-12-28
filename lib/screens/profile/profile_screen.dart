import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            const CircleAvatar(
              radius: 45,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),

            const SizedBox(height: 12),

            const Text(
              'Usuario',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 4),

            const Text(
              'usuario@email.com',
              style: TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 30),

            // Opciones
            _profileOption(icon: Icons.receipt_long, title: 'Mis pedidos'),
            _profileOption(icon: Icons.favorite_border, title: 'Favoritos'),
            _profileOption(icon: Icons.settings, title: 'Configuración'),
            _profileOption(
              icon: Icons.logout,
              title: 'Cerrar sesión',
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileOption({
    required IconData icon,
    required String title,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: isLogout ? Colors.red : Colors.black),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: isLogout ? Colors.red : Colors.black,
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
