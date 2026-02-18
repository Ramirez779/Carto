import 'package:flutter/material.dart';
import '../../../ui/design_tokens.dart';

/// Item interactivo del menú de perfil con animación de presión
class ProfileTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isLogout;
  final VoidCallback onTap;
  final String? badge; // para mostrar badges

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    this.isLogout = false,
    required this.onTap,
    this.badge,
  });

  @override
  State<ProfileTile> createState() => _ProfileTileState();
}

class _ProfileTileState extends State<ProfileTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: _buildDecoration(),
        child: Row(
          children: [
            _buildIcon(),
            const SizedBox(width: 14),
            _buildTitle(),
            if (widget.badge != null) _buildBadge(),
            _buildArrow(),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: _isPressed ? AppColors.background : AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.m),
      border: Border.all(
        color: Colors.black.withOpacity(0.03),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: widget.isLogout
            ? AppColors.danger.withOpacity(0.1)
            : Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.s),
      ),
      child: Icon(
        widget.icon,
        size: 20,
        color: widget.isLogout ? AppColors.danger : Colors.black,
      ),
    );
  }

  Widget _buildTitle() {
    return Expanded(
      child: Text(
        widget.title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: widget.isLogout
              ? AppColors.danger
              : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        widget.badge!,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildArrow() {
    return Icon(
      Icons.arrow_forward_ios_rounded,
      size: 16,
      color: Colors.black.withOpacity(0.5),
    );
  }
}