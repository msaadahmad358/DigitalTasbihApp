import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/tasbih_item.dart'; // Add this

class TasbihListItem extends StatelessWidget {
  final TasbihItem item;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TasbihListItem({
    super.key,
    required this.item,
    required this.count,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        gradient: isSelected ? AppConstants.primaryGradient : null,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppConstants.secondaryColor.withAlpha(38),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          leading: CircleAvatar(
            radius: 18,
            backgroundColor: isSelected ? Colors.white : Colors.grey[300],
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppConstants.secondaryColor
                    : Colors.grey[700],
              ),
            ),
          ),
          title: Text(
            item.name,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey[800],
              fontSize: 15,
            ),
          ),
          subtitle: Text(
            item.arabic,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white70 : Colors.grey[500],
            ),
          ),
          trailing: item.isDefault
              ? Icon(
                  Icons.lock_outline,
                  size: 18,
                  color: isSelected ? Colors.white70 : Colors.grey[400],
                )
              : IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: isSelected ? Colors.white70 : Colors.redAccent,
                  ),
                  onPressed: onDelete,
                ),
          onTap: onTap,
        ),
      ),
    );
  }
}
