import 'package:flutter/material.dart';
import '../../ui/design_tokens.dart';

//Botón reutilizable para confirmar el pedido
class ConfirmButton extends StatelessWidget {
  //Indica si se está procesando la acción
  final bool isLoading;

  //Controla si el botón está habilitado
  final bool isEnabled;

  //Acción que se ejecuta al presionar el botón
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
      //Deshabilita el botón si no está habilitado o está cargando
      onPressed: isEnabled && !isLoading ? onPressed : null,

      //Estilos visuales del botón
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 56),
      ),

      //Muestra un loader o el texto según el estado
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('Confirmar pedido'),
    );
  }
}