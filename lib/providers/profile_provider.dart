import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  File? _avatar;
  String _name = 'Usuario';
  String _email = 'usuario@ejemplo.com';
  String? _phone; 

  File? get avatar => _avatar;
  String get name => _name;
  String get email => _email;
  String? get phone => _phone; 

  ProfileProvider() {
    _loadAvatar();
  }

  // Cargar avatar guardado
  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final avatarPath = prefs.getString('avatar_path');
    if (avatarPath != null) {
      final file = File(avatarPath);
      if (await file.exists()) {
        _avatar = file;
        notifyListeners();
      }
    }
  }

  // Guardar avatar
  Future<void> setAvatar(File file) async {
    _avatar = file;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('avatar_path', file.path);
    notifyListeners();
  }

  // Actualizar nombre
  void updateName(String newName) {
    _name = newName;
    notifyListeners();
  }

  // Actualizar email
  void updateEmail(String newEmail) {
    _email = newEmail;
    notifyListeners();
  }

  // Actualizar teléfono
  void updatePhone(String? newPhone) {
    _phone = newPhone;
    notifyListeners();
  }

  // Limpiar datos al cerrar sesión
  Future<void> clear() async {
    _avatar = null;
    _name = 'Usuario';
    _email = 'usuario@ejemplo.com';
    _phone = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('avatar_path');
    
    notifyListeners();
  }
}