import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/animated_list_item.dart';

/// Chats screen — basic UI placeholder with dummy chat list.
class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  static const List<_ChatItem> _chats = [
    _ChatItem(name: 'Sofia Chen', msg: 'Thanks for watching! 💚', time: '2m', unread: 3),
    _ChatItem(name: 'Mia Torres', msg: 'Join my party tonight!', time: '15m', unread: 1),
    _ChatItem(name: 'Emma Ross', msg: 'Great stream today 🔥', time: '1h', unread: 0),
    _ChatItem(name: 'Nora Kim', msg: 'See you next stream!', time: '3h', unread: 0),
    _ChatItem(name: 'Lily Park', msg: 'You: Thanks! 😊', time: '5h', unread: 0),
    _ChatItem(name: 'Alex K.', msg: 'Party room is live now!', time: '1d', unread: 2),
    _ChatItem(name: 'Aisha Khan', msg: 'Followed you back ✨', time: '2d', unread: 0),
  ];

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header + search
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text('Messages 💬',
              style: AppTheme.headlineMedium.copyWith(fontSize: 20)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search messages...',
                prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(), // smooth scrolling
            itemCount: _chats.length,
            itemBuilder: (_, i) => AnimatedListItem(
              index: i,
              slideX: 0.05,
              slideY: 0.0,
              child: _ChatTile(item: _chats[i]),
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

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.item});
  final _ChatItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primary.withAlpha(20),
            child: Text(
              item.name[0],
              style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppColors.gradientEnd,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
      title: Text(item.name,
          style: AppTheme.labelMedium.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(item.msg,
          style: AppTheme.bodySmall,
          overflow: TextOverflow.ellipsis),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(item.time, style: AppTheme.bodySmall.copyWith(fontSize: 11)),
          const SizedBox(height: 4),
          if (item.unread > 0)
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text('${item.unread}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700)),
            ),
        ],
      ),
    );
  }
}

class _ChatItem {
  const _ChatItem(
      {required this.name,
      required this.msg,
      required this.time,
      required this.unread});
  final String name;
  final String msg;
  final String time;
  final int unread;
}
