import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/home_provider.dart';

/// Animated country filter chip for the horizontal filter row.
class CountryFilterChip extends StatelessWidget {
  const CountryFilterChip({
    super.key,
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  final CountryFilter filter;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.transparent : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(filter.flag, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 5),
            Text(
              filter.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
