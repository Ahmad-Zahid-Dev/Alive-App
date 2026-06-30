import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../models/home_item_model.dart';
import '../providers/home_provider.dart';

/// Stream card for the 2-column home grid.
/// Supports Hero transition via [heroTag].
class StreamCard extends StatelessWidget {
  const StreamCard({
    super.key,
    required this.item,
    required this.index,
  });

  final HomeItemModel item;
  final int index;

  String get heroTag => 'stream_card_${item.id}';

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Thumbnail ───────────────────────────────────────────────
            CachedNetworkImage(
              imageUrl: item.thumbnailUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: AppColors.cardDark),
              errorWidget: (_, __, ___) =>
                  Container(color: AppColors.cardDark),
            ),
            // ── Dark overlay gradient ───────────────────────────────────
            const DecoratedBox(
              decoration: BoxDecoration(gradient: AppColors.cardOverlay),
            ),
            // ── Viewer count badge (top-left) ───────────────────────────
            Positioned(
              top: 8,
              left: 8,
              child: _ViewerBadge(count: item.viewerCountFormatted),
            ),
            // ── Streamer info (bottom) ──────────────────────────────────
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Row(
                children: [
                  // Avatar placeholder
                  const CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white38,
                    child: Icon(Icons.person,
                        size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 6),
                  // Name + flag stacked vertically to prevent truncation (matches Image 1)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.streamerName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          item.flagEmoji,
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  // Follow button
                  _FollowButton(item: item),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewerBadge extends StatelessWidget {
  const _ViewerBadge({required this.count});
  final String count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(140),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.remove_red_eye_outlined,
              color: Colors.white, size: 11),
          const SizedBox(width: 4),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  const _FollowButton({required this.item});
  final HomeItemModel item;

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final isFollowing = homeProvider.isFollowing(item.id);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        context.read<HomeProvider>().toggleFollow(item.id);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isFollowing ? Colors.white38 : AppColors.followButton,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          isFollowing ? '✓ Following' : '+ Follow',
          style: TextStyle(
            color: isFollowing ? Colors.white : Colors.black87,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
