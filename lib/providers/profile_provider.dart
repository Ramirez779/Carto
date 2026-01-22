import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  File? _avatar;
  String? _avatarPath;
  String _name = 'Usuario';
  String _email = 'usuario@email.com';

  String get name => _name;
  String get email => _email;
  File? get avatar => _avatar;

  ProfileProvider() {
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final path = prefs.getString('profile_avatar_path');
      _name = prefs.getString('profile_name') ?? 'Usuario';
      _email = prefs.getString('profile_email') ?? 'usuario@email.com';

      if (path != null && await File(path).exists()) {
        _avatar = File(path);
        _avatarPath = path;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading profile data: $e');
    }
  }

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

  bool get hasAvatar => _avatar != null;
}