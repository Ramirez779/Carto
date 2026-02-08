import 'package:flutter/material.dart';
import '../../ui/design_tokens.dart';
import 'section_card.dart';

//Enumeración para tipos de pago
enum PaymentMethod {
  creditCard,
  debitCard,
  paypal,
  cashOnDelivery,
  bankTransfer,
}

//Sección del checkout que muestra los métodos de pago
class PaymentSection extends StatefulWidget {
  const PaymentSection({super.key});

  @override
  State<PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  PaymentMethod _selectedMethod = PaymentMethod.creditCard;

  //Mapeo de métodos de pago a datos
  final Map<PaymentMethod, Map<String, dynamic>> _paymentMethods = {
    PaymentMethod.creditCard: {
      'name': 'Tarjeta de crédito',
      'icon': Icons.credit_card_outlined,
      'description': 'Paga con tu tarjeta de crédito',
      'color': AppColors.primary,
    },
    PaymentMethod.debitCard: {
      'name': 'Tarjeta de débito',
      'icon': Icons.credit_card,
      'description': 'Paga directamente desde tu cuenta',
      'color': Colors.blue.shade700,
    },
    PaymentMethod.paypal: {
      'name': 'PayPal',
      'icon': Icons.account_balance_wallet_outlined,
      'description': 'Pago rápido y seguro',
      'color': const Color(0xff003087),
    },
    PaymentMethod.cashOnDelivery: {
      'name': 'Pago contra entrega',
      'icon': Icons.local_shipping_outlined,
      'description': 'Paga cuando recibas tu pedido',
      'color': Colors.green.shade700,
    },
    PaymentMethod.bankTransfer: {
      'name': 'Transferencia bancaria',
      'icon': Icons.account_balance_outlined,
      'description': 'Transfiere desde tu banco',
      'color': Colors.purple.shade700,
    },
  };

  //Método para obtener datos del método seleccionado
  Map<String, dynamic> get _selectedPaymentData =>
      _paymentMethods[_selectedMethod]!;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBackground = isDark
        ? AppColors.surfaceDark.withOpacity(0.6)
        : AppColors.surfaceLight;

    return SectionCard(
      title: 'Método de pago',
      icon: Icons.payment_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Método seleccionado (destacado) - Principio de Von Restorff
          _buildSelectedPaymentMethod(isDark, cardBackground),

          const SizedBox(height: 16),

          //Texto para cambiar método
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Cambiar método de pago',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          //Lista de métodos alternativos
          ..._buildAlternativeMethods(isDark),
        ],
      ),
    );
  }

  //Método seleccionado (destacado)
  Widget _buildSelectedPaymentMethod(bool isDark, Color cardBackground) {
    final methodData = _selectedPaymentData;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: methodData['color'] as Color,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: methodData['color'].withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          //Ícono con color distintivo
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: methodData['color'] as Color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              methodData['icon'] as IconData,
              color: Colors.white,
              size: 20,
            ),
          ),

          const SizedBox(width: 16),

          //Información del método
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  methodData['name'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  methodData['description'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          //Indicador de selección
          Icon(
            Icons.check_circle_rounded,
            color: methodData['color'] as Color,
            size: 22,
          ),
        ],
      ),
    );
  }

  //Métodos alternativos
  List<Widget> _buildAlternativeMethods(bool isDark) {
    return _paymentMethods.entries
        .where((entry) => entry.key != _selectedMethod)
        .map((entry) {
      final methodData = entry.value;

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedMethod = entry.key;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDark.withOpacity(0.3)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                //Ícono del método
                Icon(
                  methodData['icon'] as IconData,
                  color: methodData['color'] as Color,
                  size: 22,
                ),

                const SizedBox(width: 12),

                //Nombre del método
                Expanded(
                  child: Text(
                    methodData['name'] as String,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                //Flecha de selección (Ley de Fitts - área táctil amplia)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.surfaceDark : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  // Método público para obtener el método seleccionado
  PaymentMethod get selectedMethod => _selectedMethod;
}