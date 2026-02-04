import 'package:flutter/material.dart';
import '../../ui/design_tokens.dart';

// Botón reutilizable para confirmar el pedido
class ConfirmButton extends StatelessWidget {
  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onPressed;

  const ConfirmButton({
    super.key,
    required this.isLoading,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
        ),
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('Confirmar pedido'),
    );
  }
}