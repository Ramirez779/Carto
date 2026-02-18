import 'dart:io';
import 'package:flutter/material.dart';
import '../../../ui/design_tokens.dart';

/// Header del perfil con avatar editable, nombre y email
class ProfileHeader extends StatelessWidget {
  final File? avatar;
  final String name;
  final String email;
  final VoidCallback onTapAvatar;

  const ProfileHeader({
    super.key,
    required this.avatar,
    required this.name,
    required this.email,
    required this.onTapAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.l),
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      child: Column(
        children: [
          _buildAvatar(),
          const SizedBox(height: 16),
          _buildName(),
          const SizedBox(height: 4),
          _buildEmail(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return GestureDetector(
      onTap: onTapAvatar,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.background,
            backgroundImage: avatar != null ? FileImage(avatar!) : null,
            child: avatar == null
                ? Icon(
                    Icons.person_outline,
                    size: 40,
                    color: AppColors.textSecondary,
                  )
                : null,
          ),
          _buildCameraIcon(),
        ],
      ),
    );
  }

  Widget _buildCameraIcon() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Icon(
        Icons.camera_alt_outlined,
        size: 16,
        color: Colors.white,
      ),
    );
  }

  Widget _buildName() {
    return Text(
      name,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildEmail() {
    return Text(
      email,
      style: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
    );
  }
}