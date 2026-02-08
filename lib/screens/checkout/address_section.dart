import 'package:flutter/material.dart';
import '../../ui/design_tokens.dart';
import 'section_card.dart';

//Se muestra la direccion de entrega
class AddressSection extends StatefulWidget {
  const AddressSection({super.key});

  @override
  State<AddressSection> createState() => _AddressSectionState();
}

class _AddressSectionState extends State<AddressSection> {
  //direcciones
  final List<Map<String, String>> _addresses = [
    {
      'name': 'Casa',
      'address': 'Calle Principal #123',
      'city': 'Sa Salvador',
      'isDefault': 'true',
    },
    {
      'name': 'Oficina',
      'address': 'Av. Reforma #456',
      'city': 'San Miguel',
      'isDefault': 'false',
    },
  ];

  int _selectedIndex = 0;

  void _selectAddress(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentAddress = _addresses[_selectedIndex];
    final isDefault = currentAddress['isDefault'] == 'true';

    return SectionCard(
      title: 'Dirección de entrega',
      icon: Icons.location_on_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Dirección seleccionada
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDark.withOpacity(0.3)
                  : AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppRadius.s),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Indicador de selección
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 12),

                //Información de dirección
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Nombre con badge
                      Row(
                        children: [
                          Text(
                            currentAddress['name']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimary,
                            ),
                          ),
                          if (isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Predeterminada',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Dirección
                      Text(
                        currentAddress['address']!,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 2),

                      // Ciudad
                      Text(
                        currentAddress['city']!,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textSecondaryDark.withOpacity(0.8)
                              : AppColors.textSecondary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          //Otras direcciones
          if (_addresses.length > 1) ...[
            Text(
              'Otras direcciones',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            ..._addresses
                .asMap()
                .entries
                .where((entry) => entry.key != _selectedIndex)
                .map((entry) {
              final index = entry.key;
              final address = entry.value;

              return GestureDetector(
                onTap: () => _selectAddress(index),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surfaceDark.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(AppRadius.s),
                    border: Border.all(
                      color: isDark
                          ? AppColors.borderDark.withOpacity(0.3)
                          : AppColors.borderLight.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      //Círculo sin seleccionar
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondary,
                            width: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              address['name']!,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              address['address']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],

          //Botón para agregar
          const SizedBox(height: 12),

          GestureDetector(
            onTap: () {
              //Navegar a pantalla de agregar dirección
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color:
                        isDark ? AppColors.borderDark : AppColors.borderLight,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Agregar dirección',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}