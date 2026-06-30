import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/animated_list_item.dart';

/// Party screen — basic UI placeholder.
class PartyScreen extends StatelessWidget {
  const PartyScreen({super.key});

  static const List<_PartyItem> _parties = [
    _PartyItem(title: 'Game Night 🎮', host: 'Alex K.', viewers: 1240, emoji: '🎮'),
    _PartyItem(title: 'Music Jam 🎸', host: 'Sofia Chen', viewers: 892, emoji: '🎸'),
    _PartyItem(title: 'Dance Battle 💃', host: 'Mia Torres', viewers: 3410, emoji: '💃'),
    _PartyItem(title: 'Cooking Live 🍳', host: 'Emma Ross', viewers: 560, emoji: '🍳'),
    _PartyItem(title: 'Study Session 📚', host: 'Nora Kim', viewers: 230, emoji: '📚'),
    _PartyItem(title: 'Karaoke Night 🎤', host: 'Lily Park', viewers: 1870, emoji: '🎤'),
  ];

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Party Rooms 🎉',
              style: AppTheme.headlineMedium.copyWith(fontSize: 20)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Join a live party room',
              style: AppTheme.bodyMedium),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(), // smooth scrolling
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _parties.length,
            itemBuilder: (_, i) => AnimatedListItem(
              index: i,
              slideX: 0.1,
              slideY: 0.0,
              child: _PartyCard(item: _parties[i]),
            ),
          ),
        ),
      ],
    );

    if (isLandscape) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: content,
        ),
      );
    }
    return content;
  }
}

class _PartyCard extends StatelessWidget {
  const _PartyCard({required this.item});
  final _PartyItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(item.emoji, style: const TextStyle(fontSize: 24)),
          ),
        ),
        title: Text(item.title,
            style: AppTheme.labelMedium.copyWith(fontWeight: FontWeight.w700)),
        subtitle: Text('Host: ${item.host}', style: AppTheme.bodySmall),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Join',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 4),
            Text('${_fmt(item.viewers)} watching',
                style: AppTheme.bodySmall.copyWith(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  String _fmt(int n) => n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}K' : '$n';
}

class _PartyItem {
  const _PartyItem(
      {required this.title,
      required this.host,
      required this.viewers,
      required this.emoji});
  final String title;
  final String host;
  final int viewers;
  final String emoji;
}
