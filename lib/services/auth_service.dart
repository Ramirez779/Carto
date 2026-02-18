import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUser = 'userData';
  static const String _keyUsers = 'registeredUsers'; // Simula BD

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  //registro
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Obtener usuarios registrados
      final usersJson = prefs.getString(_keyUsers);
      final List<dynamic> users = 
          usersJson != null ? jsonDecode(usersJson) : [];

      // Verificar si el email ya existe
      final emailExists = users.any((u) => u['email'] == email);
      if (emailExists) {
        return {
          'success': false,
          'message': 'Este correo ya está registrado',
        };
      }

      // Crear nuevo usuario
      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
      );

      // Guardar usuario con contraseña
      users.add({
        ...newUser.toJson(),
        'password': password,
      });

      await prefs.setString(_keyUsers, jsonEncode(users));

      //Iniciar sesión automáticamente después del registro
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUser, jsonEncode(newUser.toJson()));

      return {
        'success': true,
        'message': 'Registro exitoso',
        'user': newUser,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al registrar. Intenta de nuevo.',
      };
    }
  }

  //login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Obtener usuarios registrados
      final usersJson = prefs.getString(_keyUsers);
      
      //si no hay usuarios, mensaje más claro
      if (usersJson == null) {
        return {
          'success': false,
          'message': 'Credenciales incorrectas',  
        };
      }

      final List<dynamic> users = jsonDecode(usersJson);

      // Buscar usuario con email y password coincidentes
      dynamic userData;
      try {
        userData = users.firstWhere(
          (u) => u['email'] == email && u['password'] == password,
        );
      } catch (e) {
        // No se encontró el usuario
        userData = null;
      }

      if (userData == null) {
        return {
          'success': false,
          'message': 'Credenciales incorrectas',  // mensaje 
        };
      }

      // Crear modelo de usuario (sin password)
      final user = UserModel.fromJson(userData);

      // Guardar sesión
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUser, jsonEncode(user.toJson()));

      return {
        'success': true,
        'message': 'Login exitoso',
        'user': user,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al iniciar sesión. Intenta de nuevo.',
      };
    }
  }

  //cerrar seción
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyUser);
  }

  //verificar seción
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // obtener user actual
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_keyUser);
    
    if (userJson == null) return null;
    
    return UserModel.fromJson(jsonDecode(userJson));
  }

  // Actualizar usuario
  Future<void> updateUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }
}