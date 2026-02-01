import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../ui/design_tokens.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        final profileProvider = context.read<ProfileProvider>();
        profileProvider.setAvatar(File(image.path));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              sliver: SliverToBoxAdapter(
                child: _ProfileHeader(
                  avatar: profile.avatar,
                  name: profile.name,
                  email: profile.email,
                  onTapAvatar: _pickImage,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // SECCIÓN CUENTA
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: _SectionTitle(title: 'Cuenta'),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _ProfileTile(
                      icon: Icons.receipt_long_outlined,
                      title: 'Mis pedidos',
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.favorite_outline,
                      title: 'Favoritos',
                      onTap: () {},
                    ),
                    _ProfileTile(
                      icon: Icons.settings_outlined,
                      title: 'Configuración',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // SECCIÓN SESIÓN
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: _SectionTitle(title: 'Sesión'),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: _ProfileTile(
                  icon: Icons.logout_outlined,
                  title: 'Cerrar sesión',
                  isLogout: true,
                  onTap: () {},
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 48)),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final File? avatar;
  final String name;
  final String email;
  final VoidCallback onTapAvatar;

  const _ProfileHeader({
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
          width: 1,
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
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
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ProfileTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isLogout;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    this.isLogout = false,
    required this.onTap,
  });

  @override
  State<_ProfileTile> createState() => _ProfileTileState();
}

class _ProfileTileState extends State<_ProfileTile> {
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
        decoration: BoxDecoration(
          color: _isPressed
              ? AppColors.background
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.m),
          border: Border.all(
            color: Colors.black.withOpacity(0.03),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: widget.isLogout
                    ? AppColors.danger.withOpacity(0.1)
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.s),
              ),
              child: Icon(
                widget.icon,
                size: 20,
                color: widget.isLogout
                    ? AppColors.danger
                    : AppColors.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
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
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}