import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../ui/design_tokens.dart';

// Importar las nuevas pantallas
import './widgets/my_orders_screen.dart';
import './widgets/favorites_screen.dart';
import './widgets/edit_profile_screen.dart';
import './widgets/help_center_screen.dart';

/// Clase con toda la lógica del perfil separada del UI
class ProfileLogic {
  final BuildContext context;
  final ImagePicker _picker = ImagePicker();

  ProfileLogic(this.context);

  // seleccionar imagen
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null && context.mounted) {
        context.read<ProfileProvider>().setAvatar(File(image.path));
        _showSuccessSnackBar('Foto actualizada');
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (context.mounted) {
        _showErrorSnackBar('Error al seleccionar la imagen');
      }
    }
  }

  // serrar seción
  Future<void> handleLogout() async {
    final confirm = await _showLogoutDialog();

    if (confirm == true && context.mounted) {
      await context.read<AuthProvider>().logout();

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );
      }
    }
  }

  // navegar a mis pedidos
  void navigateToOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyOrdersScreen(),
      ),
    );
  }

  // ir a favoritos
  void navigateToFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FavoritesScreen(),
      ),
    );
  }

  // ir a editar perfil
  void navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );
  }

  // centro de ayuda
  void navigateToHelp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HelpCenterScreen(),
      ),
    );
  }

  // helpers privados

  Future<bool?> _showLogoutDialog() {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.danger,
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}