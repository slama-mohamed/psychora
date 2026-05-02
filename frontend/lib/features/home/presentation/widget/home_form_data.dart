import 'package:flutter/material.dart';
import 'package:psychora/features/home/presentation/widget/quick_action_item.dart';

class HomeFormData {
  HomeFormData._();

  static final List<QuickActionItem> quickActions = [
    QuickActionItem(
      title: 'New Patient',
      icon: Icons.add,
      backgroundColor: Color(0xFF3D9970),
      foregroundColor: Colors.white,
      onTap: null,
    ),
    QuickActionItem(
      title: 'Start Chat',
      icon: Icons.chat_bubble_outline,
      backgroundColor: Color(0xFF3B82F6),
      foregroundColor: Colors.white,
      onTap: null,
    ),
    QuickActionItem(
      title: 'Resources',
      icon: Icons.menu_book_outlined,
      backgroundColor: Color(0xFF8B5CF6),
      foregroundColor: Colors.white,
      onTap: () {
        // TODO: Add navigation to resources page
        print('Resources tapped');
      },
    ),
    QuickActionItem(
      title: 'All Notes',
      icon: Icons.note_alt_outlined,
      backgroundColor: Color(0xFFF97316),
      foregroundColor: Colors.white,
      onTap: () {
        // TODO: Add navigation to notes page
        print('All Notes tapped');
      },
    ),
  ];
}