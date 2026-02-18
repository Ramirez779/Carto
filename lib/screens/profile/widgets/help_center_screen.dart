import 'package:flutter/material.dart';
import '../../../ui/design_tokens.dart';

/// Centro de ayuda optimizado: sin barra de búsqueda ni iconos de acceso rápido.
class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  // Secciones de ayuda organizadas por categoría
  static final List<Map<String, dynamic>> _sections = [
    {
      'category': 'Pedidos y Envíos',
      'icon': Icons.local_shipping_outlined,
      'faqs': [
        {
          'question': '¿Cómo puedo rastrear mi pedido?',
          'answer':
              'Ve a "Mis pedidos" en tu perfil. Ahí encontrarás el estado actual de cada pedido y el número de seguimiento si ya fue enviado.',
        },
        {
          'question': '¿Cuánto tarda el envío?',
          'answer':
              'El envío estándar tarda 3-5 días hábiles. El envío express está disponible en 1-2 días hábiles con costo adicional.',
        },
      ],
    },
    {
      'category': 'Pagos y Devoluciones',
      'icon': Icons.payment_outlined,
      'faqs': [
        {
          'question': '¿Cuáles son los métodos de pago aceptados?',
          'answer':
              'Aceptamos tarjetas de crédito/débito (Visa, Mastercard, American Express), PayPal y transferencias bancarias.',
        },
        {
          'question': '¿Puedo devolver un producto?',
          'answer':
              'Sí, tienes 30 días desde la recepción para devolver productos en condiciones originales. El reembolso se procesa en 5-7 días hábiles.',
        },
      ],
    },
    {
      'category': 'Cuenta',
      'icon': Icons.account_circle_outlined,
      'faqs': [
        {
          'question': '¿Cómo cambio mi contraseña?',
          'answer':
              'Actualmente esta función está en desarrollo. Por ahora, contáctanos para ayudarte con el cambio de contraseña.',
        },
        {
          'question': '¿Puedo cambiar mi correo electrónico?',
          'answer':
              'El correo es tu identificador único. Para cambiarlo, contáctanos directamente a soporte@carto.com',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Centro de ayuda'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      // SafeArea evita que el contenido choque con la barra de navegación del celular
      body: SafeArea(
        bottom: true,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 32),

            // FAQs
            ..._sections.map((section) => _buildSection(
                  category: section['category'],
                  icon: section['icon'],
                  faqs: section['faqs'],
                )),

            const SizedBox(height: 24),

            // Botones de contacto
            _buildContactButtons(context),

            // Espacio de seguridad final para que el scroll respire
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.l),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.help_outline_rounded,
            size: 48,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          Text(
            '¿En qué podemos ayudarte?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Encuentra respuestas rápidas o contáctanos',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String category,
    required IconData icon,
    required List<Map<String, String>> faqs,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                category,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        ...faqs.map((faq) => _FaqItem(
              question: faq['question']!,
              answer: faq['answer']!,
            )),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildContactButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '¿No encontraste lo que buscabas?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.email_outlined),
            label: const Text(
              'Enviar correo a soporte',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text(
              'Chat con soporte',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
            ),
          ),
        ),
      ],
    );
  }
}

class _FaqItem extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.m),
        border: Border.all(
          color: _isExpanded
              ? AppColors.primary.withOpacity(0.3)
              : Colors.black.withOpacity(0.05),
          width: _isExpanded ? 1.5 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.m),
        child: Column(
          children: [
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.question,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _isExpanded
                          ? Icons.remove_circle_outline
                          : Icons.add_circle_outline,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
            if (_isExpanded)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                ),
                child: Text(
                  widget.answer,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}