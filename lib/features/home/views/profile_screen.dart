import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';

/// Profile screen with user info and logout option.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(), // smooth scrolling
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isLandscape ? 600 : double.infinity,
          ),
          child: Column(
            children: [
              // ── Profile Header ─────────────────────────────────────────────
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        color: Colors.white24,
                      ),
                      child: user?.photoUrl.isNotEmpty == true
                          ? ClipOval(
                              child: Image.network(
                                user!.photoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.person,
                                        size: 48, color: Colors.white),
                              ),
                            )
                          : const Icon(Icons.person, size: 48, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.name.isNotEmpty == true
                          ? user!.name
                          : 'Guest User',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '',
                      style: TextStyle(
                        color: Colors.white.withAlpha(200),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _StatBadge(label: 'Following', value: '128'),
                        _vDivider(),
                        const _StatBadge(label: 'Followers', value: '4.2K'),
                        _vDivider(),
                        const _StatBadge(label: 'Likes', value: '18K'),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Menu Options ───────────────────────────────────────────────
              const SizedBox(height: 8),
              _MenuSection(
                title: 'Account',
                items: [
                  _MenuItem(Icons.edit_outlined, 'Edit Profile', () {}),
                  _MenuItem(Icons.wallet_outlined, 'My Coins', () {}),
                  _MenuItem(Icons.diamond_outlined, 'VIP Subscription', () {}),
                ],
              ),
              _MenuSection(
                title: 'Content',
                items: [
                  _MenuItem(Icons.live_tv_outlined, 'My Streams', () {}),
                  _MenuItem(Icons.favorite_outline, 'Liked Videos', () {}),
                  _MenuItem(Icons.bookmark_outline, 'Saved', () {}),
                ],
              ),
              _MenuSection(
                title: 'Settings',
                items: [
                  _MenuItem(Icons.notifications_outlined, 'Notifications', () {}),
                  _MenuItem(Icons.privacy_tip_outlined, 'Privacy', () {}),
                  _MenuItem(Icons.help_outline, 'Help & Support', () {}),
                ],
              ),

              // ── Logout Button ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _confirmLogout(context, auth);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.red.shade100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded,
                            color: Colors.red.shade600, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out?',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              HapticFeedback.mediumImpact();
              Navigator.pop(context);
              await auth.signOut();
              if (context.mounted) {
                context.go(AppConstants.routeLogin);
              }
            },
            child: Text('Log Out',
                style: TextStyle(
                    color: Colors.red.shade600,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _StatBadge extends StatelessWidget {
  const _StatBadge({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withAlpha(200), fontSize: 12)),
        ],
      ),
    );
  }
}

Widget _vDivider() => Container(
      width: 1, height: 32, color: Colors.white.withAlpha(80));

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.title, required this.items});
  final String title;
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Text(title,
              style: AppTheme.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                  letterSpacing: 1)),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final isLast = e.key == items.length - 1;
              return Column(
                children: [
                  ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(18),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(e.value.icon,
                          color: AppColors.primary, size: 20),
                    ),
                    title: Text(e.value.label,
                        style: AppTheme.labelMedium),
                    trailing: const Icon(Icons.chevron_right,
                        color: Colors.grey, size: 20),
                    onTap: e.value.onTap,
                  ),
                  if (!isLast)
                    Divider(
                        height: 1,
                        indent: 64,
                        endIndent: 16,
                        color: Colors.grey.shade100),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  const _MenuItem(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}
