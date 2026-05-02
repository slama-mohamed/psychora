import 'package:flutter/material.dart';

import '../function/diagnostic_resource.dart';
import 'resources_header.dart';
import 'resources_card.dart';
import 'resources_filter_tabs.dart';
import 'resources_search_bar.dart';

class ResourcesForm extends StatefulWidget {
  const ResourcesForm({super.key});

  @override
  State<ResourcesForm> createState() => _ResourcesFormState();
}

class _ResourcesFormState extends State<ResourcesForm> {
  String _searchQuery = '';
  ResourceType _selectedType = ResourceType.all;

  List<DiagnosticResource> get _filtered {
    final q = _searchQuery.toLowerCase();
    return DiagnosticResourceData.items.where((r) {
      final matchType = _selectedType == ResourceType.all || r.type == _selectedType;
      final matchSearch = q.isEmpty ||
          r.title.toLowerCase().contains(q) ||
          r.subtitle.toLowerCase().contains(q) ||
          r.category.toLowerCase().contains(q);
      return matchType && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Forcer la perte de focus quand on clique en dehors
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ResourcesHeader(),
          ResourcesSearchBar(
            onChanged: (v) => setState(() => _searchQuery = v),
            onFocusLost: () {
              // Le focus est perdu, on peut faire quelque chose si nécessaire
            },
          ),
          const SizedBox(height: 12),
          ResourcesFilterTabs(
            selected: _selectedType,
            onChanged: (t) => setState(() => _selectedType = t),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filtered.isEmpty
                ? const ResourcesEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) => ResourceCard(
                      resource: _filtered[i],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Empty State ────────────────────────────────────────────────────────────────

class ResourcesEmptyState extends StatelessWidget {
  const ResourcesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No resources found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try modifying your search criteria',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}