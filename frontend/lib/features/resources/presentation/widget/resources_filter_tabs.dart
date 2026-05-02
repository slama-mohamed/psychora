import 'package:flutter/material.dart';
import '../function/diagnostic_resource.dart';
import 'resources_header.dart'; // kGreen, kGreenLight

class ResourcesFilterTabs extends StatelessWidget {
  final ResourceType selected;
  final ValueChanged<ResourceType> onChanged;

  const ResourcesFilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _tabs = [
    (ResourceType.all, 'All'),
    (ResourceType.diagnostics, 'Diagnostics'),
    (ResourceType.treatment, 'Treatment'),
    (ResourceType.guidelines, 'Guidelines'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final isSelected = selected == _tabs[i].$1;
          return GestureDetector(
            onTap: () => onChanged(_tabs[i].$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
              decoration: BoxDecoration(
                color: isSelected ? kGreen : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? kGreen : Colors.grey.shade300,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: kGreen.withValues(alpha: 0.28),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                _tabs[i].$2,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}