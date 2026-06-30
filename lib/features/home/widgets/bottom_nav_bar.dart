import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final safeBottomPad = bottomPad > 0 ? bottomPad : 12.0;
    final barHeight = 64.0 + safeBottomPad;

    return SizedBox(
      height: barHeight + 28,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              painter: _NavBarPainter(),
              child: SizedBox(
                height: barHeight,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.orientationOf(context) == Orientation.landscape ? 600 : double.infinity,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: safeBottomPad),
                      child: Row(
                        children: [
                          _NavTile(
                            icon: Icons.home_rounded,
                            label: 'Home',
                            isSelected: currentIndex == 0,
                            onTap: () => onTap(0),
                          ),
                          _NavTile(
                            icon: Icons.celebration_outlined,
                            label: 'Party',
                            isSelected: currentIndex == 1,
                            onTap: () => onTap(1),
                          ),
                          const Expanded(child: SizedBox()),
                          _NavTile(
                            icon: Icons.send_outlined,
                            label: 'Chats',
                            isSelected: currentIndex == 3,
                            onTap: () => onTap(3),
                          ),
                          _NavTile(
                            icon: Icons.person_outline_rounded,
                            label: 'Profile',
                            isSelected: currentIndex == 4,
                            onTap: () => onTap(4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onTap(2);
                },
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(30),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.sensors_rounded,
                    color: AppColors.primary,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: safeBottomPad + 4,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Go Live',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withAlpha(220),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? Colors.white
                  : Colors.white.withAlpha(160),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? Colors.white
                    : Colors.white.withAlpha(160),
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          AppColors.gradientStart,
          AppColors.gradientEnd,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final centerX = size.width / 2;
    const notchWidth = 70.0;
    const notchDepth = 22.0;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(centerX - notchWidth, 0)
      ..cubicTo(
        centerX - notchWidth * 0.45,
        0,
        centerX - notchWidth * 0.4,
        notchDepth,
        centerX,
        notchDepth,
      )
      ..cubicTo(
        centerX + notchWidth * 0.4,
        notchDepth,
        centerX + notchWidth * 0.45,
        0,
        centerX + notchWidth,
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
