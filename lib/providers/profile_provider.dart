import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Provider encargado de gestionar la información del perfil del usuario
class ProfileProvider extends ChangeNotifier {
  //Avatar del usuario almacenado localmente
  File? _avatar;
  String? _avatarPath;

  //Información básica del perfil
  String _name = 'Usuario';
  String _email = 'usuario@email.com';

  //Getters públicos
  String get name => _name;
  String get email => _email;
  File? get avatar => _avatar;

  ProfileProvider() {
    //Carga los datos del perfil al inicializar el provider
    _loadAvatar();
  }

  //Carga avatar y datos básicos desde SharedPreferences
  Future<void> _loadAvatar() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final path = prefs.getString('profile_avatar_path');
      _name = prefs.getString('profile_name') ?? 'Usuario';
      _email = prefs.getString('profile_email') ?? 'usuario@email.com';

      //Verifica que el archivo del avatar exista
      if (path != null && await File(path).exists()) {
        _avatar = File(path);
        _avatarPath = path;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading profile data: $e');
    }
  }

  //Actualiza nombre y correo del usuario
  Future<void> setBasicInfo({
    required String name,
    required String email,
  }) async {
    _name = name;
    _email = email;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', name);
    await prefs.setString('profile_email', email);
  }

  //Guarda un nuevo avatar del usuario
  Future<void> setAvatar(File image) async {
    try {
      _avatar = image;
      _avatarPath = image.path;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_avatar_path', image.path);
    } catch (e) {
      debugPrint('Error saving profile avatar: $e');
    }
  }

  //Elimina el avatar guardado
  Future<void> removeAvatar() async {
    try {
      _avatar = null;
      _avatarPath = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('profile_avatar_path');
    } catch (e) {
      debugPrint('Error removing profile avatar: $e');
    }
  }

  //Indica si el usuario tiene avatar asignado
  bool get hasAvatar => _avatar != null;
}