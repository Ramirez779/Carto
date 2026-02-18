class Validators {
  // Validar email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo es requerido';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un correo válido';
    }

    return null; // Válido
  }

  // Validar contraseña
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }

    if (value.length < 6) {
      return 'Mínimo 6 caracteres';
    }

    return null; // Válido
  }

  // Validar nombre
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es requerido';
    }

    if (value.length < 3) {
      return 'Mínimo 3 caracteres';
    }

    return null; // Válido
  }

  // Confirmar contraseña compara con password ingresado
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }

    if (value != password) {
      return 'Las contraseñas no coinciden';
    }

    return null; // Válido
  }
}