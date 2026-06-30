import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/dependency_injection/service_locator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/animated_list_item.dart';
import '../providers/home_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/country_filter_chip.dart';
import '../widgets/stream_card.dart';
import 'chats_screen.dart';
import 'party_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeProvider _homeProvider;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _homeProvider = sl<HomeProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeProvider.loadHomeItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _homeProvider,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: _navIndex == 2 ? 0 : _navIndex > 2 ? _navIndex - 1 : _navIndex,
            children: [
              // 0 → Home (Stream)
              Consumer<HomeProvider>(
                builder: (context, home, _) => _HomeTab(home: home),
              ),
              // 1 → Party
              const PartyScreen(),
              // 2 (was 3) → Chats
              const ChatsScreen(),
              // 3 (was 4) → Profile
              const ProfileScreen(),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: _navIndex,
          onTap: (i) {
            if (i == 2) {
              // Go Live — show dialog placeholder
              _showGoLiveDialog();
            } else {
              setState(() => _navIndex = i);
            }
          },
        ),
      ),
    );
  }

  void _showGoLiveDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.wifi_tethering_rounded,
                      color: Colors.white, size: 36),
                ),
                const SizedBox(height: 16),
                Text('Go Live', style: AppTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  'Live streaming will be available soon!',
                  style: AppTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    alignment: Alignment.center,
                    child: const Text('Got it',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Home Tab (Stream / Hot / Follow)
// ─────────────────────────────────────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  const _HomeTab({required this.home});
  final HomeProvider home;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── App Bar ────────────────────────────────────────────────────────
        _HomeAppBar(home: home),
        // ── Tab Row ────────────────────────────────────────────────────────
        _TabRow(home: home),
        const SizedBox(height: 10),
        // ── Country Filter ─────────────────────────────────────────────────
        _CountryFilterRow(home: home),
        const SizedBox(height: 10),
        // ── Stream Grid ────────────────────────────────────────────────────
        Expanded(
          child: home.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary))
              : _StreamGrid(home: home),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// App Bar
// ─────────────────────────────────────────────────────────────────────────────

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar({required this.home});
  final HomeProvider home;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Image.asset(AppConstants.logoPath, width: 40, height: 40),
          const Spacer(),
          // Notification bell
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.notifications_none_rounded,
                    size: 20, color: Colors.black54),
              ),
              if (home.notificationCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 17,
                    height: 17,
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text('${home.notificationCount}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF88DD00),
                  Color(0xFF22AA00),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.wallet_outlined,
                size: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab Row (Stream · Hot · Follow)
// ─────────────────────────────────────────────────────────────────────────────

class _TabRow extends StatelessWidget {
  const _TabRow({required this.home});
  final HomeProvider home;

  @override
  Widget build(BuildContext context) {
    const tabs = [HomeTab.stream, HomeTab.hot, HomeTab.follow];
    const labels = ['Stream', 'Hot', 'Follow'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = home.activeTab == tabs[i];
          return GestureDetector(
            onTap: () => home.selectTab(tabs[i]),
            child: Padding(
              padding: const EdgeInsets.only(right: 18),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: isSelected
                    ? AppTheme.titleLarge.copyWith(
                        color: AppColors.primary, fontSize: 17)
                    : AppTheme.titleLarge.copyWith(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                child: Text(labels[i]),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Country Filter Row
// ─────────────────────────────────────────────────────────────────────────────

class _CountryFilterRow extends StatelessWidget {
  const _CountryFilterRow({required this.home});
  final HomeProvider home;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: home.countryFilters.length,
        itemBuilder: (_, i) => CountryFilterChip(
          filter: home.countryFilters[i],
          isSelected: home.activeCountryIndex == i,
          onTap: () => home.selectCountry(i),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stream Grid — responsive aspect ratio
// ─────────────────────────────────────────────────────────────────────────────

class _StreamGrid extends StatelessWidget {
  const _StreamGrid({required this.home});
  final HomeProvider home;

  @override
  Widget build(BuildContext context) {
    final items = home.items;

    if (items.isEmpty) {
      return const Center(
        child: Text('No streams available',
            style: TextStyle(color: Colors.grey)),
      );
    }

    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    final crossAxisCount = isLandscape ? 3 : 2;

    // Responsive: use screen width to derive card aspect ratio
    final screenW = MediaQuery.sizeOf(context).width;
    final contentW = isLandscape ? screenW.clamp(0.0, 900.0) : screenW;

    final cardW = (contentW - 12 * 2 - (crossAxisCount - 1) * 8) / crossAxisCount; // padding + gaps
    final cardH = cardW * 1.35; // slightly taller than wide
    final aspectRatio = cardW / cardH;

    Widget grid = GridView.builder(
      physics: const BouncingScrollPhysics(), // smooth scrolling
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: aspectRatio.clamp(0.6, 0.85),
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => AnimatedListItem(
        index: i,
        child: StreamCard(item: items[i], index: i),
      ),
    );

    if (isLandscape) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: grid,
        ),
      );
    }
    return grid;
  }
}
