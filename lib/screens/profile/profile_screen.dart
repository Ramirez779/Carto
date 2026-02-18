import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/profile_provider.dart';
import '../../ui/design_tokens.dart';

import 'profile_logic.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_section_title.dart';
import 'widgets/profile_tile.dart';

/// Pantalla principal de perfil
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
    final logic = ProfileLogic(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // header
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              sliver: SliverToBoxAdapter(
                child: ProfileHeader(
                  avatar: profile.avatar,
                  name: profile.name,
                  email: profile.email,
                  onTapAvatar: logic.pickImage,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // compras
            _buildShoppingSection(logic),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // cuenta
            _buildAccountSection(logic),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // información
            _buildInfoSection(logic),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // seción
            _buildSessionSection(logic),

            const SliverToBoxAdapter(child: SizedBox(height: 48)),
          ],
        ),
      ),
    );
  }

  // seccion compras
  Widget _buildShoppingSection(ProfileLogic logic) {
    return SliverMainAxisGroup(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: ProfileSectionTitle(title: 'Compras'),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              ProfileTile(
                icon: Icons.receipt_long_outlined,
                title: 'Mis pedidos',
                onTap: logic.navigateToOrders,
              ),
              ProfileTile(
                icon: Icons.favorite_outline,
                title: 'Favoritos',
                onTap: logic.navigateToFavorites,
              ),
            ]),
          ),
        ),
      ],
    );
  }

  //sección cuenta
  Widget _buildAccountSection(ProfileLogic logic) {
    return SliverMainAxisGroup(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: ProfileSectionTitle(title: 'Cuenta'),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: ProfileTile(
              icon: Icons.edit_outlined,
              title: 'Editar perfil',
              onTap: logic.navigateToEditProfile,
            ),
          ),
        ),
      ],
    );
  }

  // sccioón de información
  Widget _buildInfoSection(ProfileLogic logic) {
    return SliverMainAxisGroup(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: ProfileSectionTitle(title: 'Información'),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: ProfileTile(
              icon: Icons.help_outline,
              title: 'Centro de ayuda',
              onTap: logic.navigateToHelp,
            ),
          ),
        ),
      ],
    );
  }

  //sección seción
  Widget _buildSessionSection(ProfileLogic logic) {
    return SliverMainAxisGroup(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: ProfileSectionTitle(title: 'Sesión'),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: ProfileTile(
              icon: Icons.logout_outlined,
              title: 'Cerrar sesión',
              isLogout: true,
              onTap: logic.handleLogout,
            ),
          ),
        ),
      ],
    );
  }
}