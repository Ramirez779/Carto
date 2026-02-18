import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/profile_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../ui/design_tokens.dart';

/// Pantalla para editar información del perfil
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Cargar datos reales del usuario autenticado
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();

    // Usar datos del AuthProvider
    _nameController = TextEditingController(
      text: authProvider.user?.name ?? profileProvider.name,
    );
    _emailController = TextEditingController(
      text: authProvider.user?.email ?? profileProvider.email,
    );
    _phoneController = TextEditingController(
      text: profileProvider.phone ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Editar perfil'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Información del usuario actual
            _buildUserInfo(),
            const SizedBox(height: 24),

            // Título de sección
            Text(
              'Información personal',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),

            // Campo: Nombre
            _buildTextField(
              controller: _nameController,
              label: 'Nombre completo',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El nombre es requerido';
                }
                if (value.length < 3) {
                  return 'Mínimo 3 caracteres';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Campo: Email (solo lectura)
            _buildTextField(
              controller: _emailController,
              label: 'Correo electrónico',
              icon: Icons.email_outlined,
              enabled: false,
              helperText: 'El correo no se puede cambiar',
            ),

            const SizedBox(height: 16),

            // Campo: Teléfono
            _buildTextField(
              controller: _phoneController,
              label: 'Teléfono (opcional)',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (value.length < 8) {
                    return 'Teléfono inválido (mínimo 8 dígitos)';
                  }
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            // Botón guardar
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Guardar cambios',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Información del usuario actual
  Widget _buildUserInfo() {
    final authProvider = context.watch<AuthProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppRadius.m),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Sesión iniciada como: ${authProvider.user?.email ?? "Usuario"}',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    String? helperText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
      ),
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        helperStyle: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
        prefixIcon: Icon(
          icon,
          color: enabled
              ? AppColors.textSecondary
              : AppColors.textSecondary.withOpacity(0.5),
        ),
        filled: true,
        fillColor: enabled ? AppColors.surface : AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.1),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.05),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(
            color: AppColors.danger,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(
            color: AppColors.danger,
            width: 2,
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simular guardado
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    // Actualizar ProfileProvider
    final profileProvider = context.read<ProfileProvider>();
    profileProvider.updateName(_nameController.text.trim());
    profileProvider.updatePhone(_phoneController.text.trim());

    // Actualizar AuthProvider también
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      final updatedUser = authProvider.user!.copyWith(
        name: _nameController.text.trim(),
      );
      await authProvider.updateProfile(updatedUser);
    }

    setState(() => _isLoading = false);

    if (!mounted) return;

    // Mostrar confirmación
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            const Text('Perfil actualizado correctamente'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.s),
        ),
      ),
    );

    // Volver a la pantalla anterior
    Navigator.pop(context);
  }
}